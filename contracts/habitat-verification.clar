;; Habitat Verification Contract
;; This contract validates and tracks protected habitat areas

(define-data-var admin principal tx-sender)

;; Data structure for habitat areas
(define-map habitats
  { habitat-id: uint }
  {
    name: (string-utf8 100),
    location: (string-utf8 100),
    size-hectares: uint,
    verified: bool,
    verification-date: uint,
    verifier: principal
  }
)

;; Counter for habitat IDs
(define-data-var habitat-counter uint u0)

;; Read-only function to get the current habitat count
(define-read-only (get-habitat-count)
  (var-get habitat-counter)
)

;; Read-only function to get habitat details
(define-read-only (get-habitat (habitat-id uint))
  (map-get? habitats { habitat-id: habitat-id })
)

;; Function to register a new habitat area
(define-public (register-habitat (name (string-utf8 100)) (location (string-utf8 100)) (size-hectares uint))
  (let
    (
      (new-id (+ (var-get habitat-counter) u1))
    )
    (begin
      (var-set habitat-counter new-id)
      (map-set habitats
        { habitat-id: new-id }
        {
          name: name,
          location: location,
          size-hectares: size-hectares,
          verified: false,
          verification-date: u0,
          verifier: tx-sender
        }
      )
      (ok new-id)
    )
  )
)

;; Function to verify a habitat area
(define-public (verify-habitat (habitat-id uint))
  (let
    (
      (habitat (unwrap! (map-get? habitats { habitat-id: habitat-id }) (err u1)))
    )
    (begin
      (asserts! (is-eq tx-sender (var-get admin)) (err u2))
      (map-set habitats
        { habitat-id: habitat-id }
        (merge habitat {
          verified: true,
          verification-date: block-height,
          verifier: tx-sender
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
