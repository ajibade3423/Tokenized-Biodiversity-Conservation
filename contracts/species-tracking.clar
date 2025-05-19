;; Species Tracking Contract
;; This contract records and tracks species population data

(define-data-var admin principal tx-sender)

;; Data structure for species
(define-map species
  { species-id: uint }
  {
    name: (string-utf8 100),
    scientific-name: (string-utf8 100),
    conservation-status: (string-utf8 20),
    habitat-id: uint
  }
)

;; Data structure for population records
(define-map population-records
  { record-id: uint }
  {
    species-id: uint,
    count: uint,
    record-date: uint,
    recorder: principal,
    notes: (string-utf8 200)
  }
)

;; Counters for IDs
(define-data-var species-counter uint u0)
(define-data-var record-counter uint u0)

;; Read-only functions to get current counts
(define-read-only (get-species-count)
  (var-get species-counter)
)

(define-read-only (get-record-count)
  (var-get record-counter)
)

;; Read-only functions to get details
(define-read-only (get-species (species-id uint))
  (map-get? species { species-id: species-id })
)

(define-read-only (get-population-record (record-id uint))
  (map-get? population-records { record-id: record-id })
)

;; Function to register a new species
(define-public (register-species
  (name (string-utf8 100))
  (scientific-name (string-utf8 100))
  (conservation-status (string-utf8 20))
  (habitat-id uint)
)
  (let
    (
      (new-id (+ (var-get species-counter) u1))
    )
    (begin
      (var-set species-counter new-id)
      (map-set species
        { species-id: new-id }
        {
          name: name,
          scientific-name: scientific-name,
          conservation-status: conservation-status,
          habitat-id: habitat-id
        }
      )
      (ok new-id)
    )
  )
)

;; Function to add a population record
(define-public (add-population-record
  (species-id uint)
  (count uint)
  (notes (string-utf8 200))
)
  (let
    (
      (new-id (+ (var-get record-counter) u1))
    )
    (begin
      (asserts! (is-some (map-get? species { species-id: species-id })) (err u1))
      (var-set record-counter new-id)
      (map-set population-records
        { record-id: new-id }
        {
          species-id: species-id,
          count: count,
          record-date: block-height,
          recorder: tx-sender,
          notes: notes
        }
      )
      (ok new-id)
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
