(require 'runtime-passwords-filesystem)

(defun runtime-password-get (key)
  (unless runtime-passwords-file
    (error "No passwords file has been set.  Set the value of `runtime-passwords-file'."))
  (runtime-password-get-from-file key runtime-passwords-file))

(provide 'runtime-passwords)
