(defvar runtime-passwords-file nil
  "A path to a file on disk containing passwords.

Passwords should be stored in this file in TSV format, one record
per line.  Each line must begin with the key for the password,
followed by a single tab character.  The value of the password
will the be rest of the content of the line, including any spaces
or tab characters.

The operating system should ensure the security of the file.")

(defun runtime-password-get-from-file (key path)
  "Return a password named KEY from the passwords file at PATH."
  (let ((password nil))
    (unless (file-exists-p path)
      (error "No password file at %s" path))
    (unless (file-readable-p path)
      (error "Password file at %s cannot be read." path))
    (unless
	(string-match
	 "0$"
	 (format "%o" (or (file-modes path) 0)))
      (warn "The file mode permissions of %s are too open.  A password file should only be readable by intended users." path))
    (with-temp-buffer
      (insert-file path)
      (beginning-of-buffer)
      (if (re-search-forward (format "^%s	" key) nil t)
	  (setq password
		(buffer-substring-no-properties (point) (line-end-position))))
      (kill-buffer (current-buffer)))
    (unless password
      (error "No password is set for %s" key))
    password))

(provide 'runtime-passwords-filesystem)
