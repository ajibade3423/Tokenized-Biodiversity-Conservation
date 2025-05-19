;; Conservation Initiative Contract
;; This contract manages conservation initiatives and projects

(define-data-var admin principal tx-sender)

;; Data structure for conservation initiatives
(define-map initiatives
  { initiative-id: uint }
  {
    name: (string-utf8 100),
    description: (string-utf8 500),
    start-date: uint,
    end-date: uint,
    status: (string-utf8 20),
    coordinator: principal,
    habitat-id: uint
  }
)

;; Data structure for initiative milestones
(define-map milestones
  { milestone-id: uint }
  {
    initiative-id: uint,
    description: (string-utf8 200),
    target-date: uint,
    completed: bool,
    completion-date: uint
  }
)

;; Counters for IDs
(define-data-var initiative-counter uint u0)
(define-data-var milestone-counter uint u0)

;; Read-only functions to get current counts
(define-read-only (get-initiative-count)
  (var-get initiative-counter)
)

(define-read-only (get-milestone-count)
  (var-get milestone-counter)
)

;; Read-only functions to get details
(define-read-only (get-initiative (initiative-id uint))
  (map-get? initiatives { initiative-id: initiative-id })
)

(define-read-only (get-milestone (milestone-id uint))
  (map-get? milestones { milestone-id: milestone-id })
)

;; Function to create a new conservation initiative
(define-public (create-initiative
  (name (string-utf8 100))
  (description (string-utf8 500))
  (start-date uint)
  (end-date uint)
  (status (string-utf8 20))
  (habitat-id uint)
)
  (let
    (
      (new-id (+ (var-get initiative-counter) u1))
    )
    (begin
      (var-set initiative-counter new-id)
      (map-set initiatives
        { initiative-id: new-id }
        {
          name: name,
          description: description,
          start-date: start-date,
          end-date: end-date,
          status: status,
          coordinator: tx-sender,
          habitat-id: habitat-id
        }
      )
      (ok new-id)
    )
  )
)

;; Function to add a milestone to an initiative
(define-public (add-milestone
  (initiative-id uint)
  (description (string-utf8 200))
  (target-date uint)
)
  (let
    (
      (new-id (+ (var-get milestone-counter) u1))
      (initiative (unwrap! (map-get? initiatives { initiative-id: initiative-id }) (err u1)))
    )
    (begin
      (asserts! (or (is-eq tx-sender (get coordinator initiative)) (is-eq tx-sender (var-get admin))) (err u2))
      (var-set milestone-counter new-id)
      (map-set milestones
        { milestone-id: new-id }
        {
          initiative-id: initiative-id,
          description: description,
          target-date: target-date,
          completed: false,
          completion-date: u0
        }
      )
      (ok new-id)
    )
  )
)

;; Function to mark a milestone as completed
(define-public (complete-milestone (milestone-id uint))
  (let
    (
      (milestone (unwrap! (map-get? milestones { milestone-id: milestone-id }) (err u1)))
      (initiative (unwrap! (map-get? initiatives { initiative-id: (get initiative-id milestone) }) (err u2)))
    )
    (begin
      (asserts! (or (is-eq tx-sender (get coordinator initiative)) (is-eq tx-sender (var-get admin))) (err u3))
      (map-set milestones
        { milestone-id: milestone-id }
        (merge milestone {
          completed: true,
          completion-date: block-height
        })
      )
      (ok true)
    )
  )
)

;; Function to update initiative status
(define-public (update-initiative-status (initiative-id uint) (new-status (string-utf8 20)))
  (let
    (
      (initiative (unwrap! (map-get? initiatives { initiative-id: initiative-id }) (err u1)))
    )
    (begin
      (asserts! (or (is-eq tx-sender (get coordinator initiative)) (is-eq tx-sender (var-get admin))) (err u2))
      (map-set initiatives
        { initiative-id: initiative-id }
        (merge initiative {
          status: new-status
        })
      )
      (ok true)
    )
  )
)

;; Function to update admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u3))
    (var-set admin new-admin)
    (ok true)
  )
)
