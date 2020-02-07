(in-package :stumpwm)

(ql:quickload "swank")

(defvar *swank-server-port* 4005)
;(setf *swank-server-port*
;      (with-restarts-menu
;          (swank:create-server :port *swank-server-port*)))
;(add-hook *restart-hook* (lambda () (swank:stop-server *swank-server-port*)))

(set-prefix-key (kbd "C-z"))

;; startup
;(run-shell-command "tint2 &" nil)
;(run-shell-command "nm-applet &" nil)
;(run-shell-command "urxvtd -q -o -f")

(defvar *TERM* "exec xterm")
;; keybindings

(define-key *root-map* (kbd "c") *TERM*)
(define-key *root-map* (kbd "C-c") *TERM*)

;; fix window borders

(setf *maxsize-border-width* 0
      *transient-border-width* 0
      *normal-border-width* 0
      *window-border-style* :thin
      *ignore-wm-inc-hints* t)

;; mode-line

(defgeneric selective-name (window))

(defparameter *window-exceptions*
  '("URxvt" "XTerm" "Emacs"))

(defmethod selective-name ((window window))
  (with-slots (class title) window
    (if (find class *window-exceptions* :test #'string=)
        title
        class)))

(defun add-window-exception (window)
  (when window
    (push (window-class window) *window-exceptions*)))

(defun remove-window-exception (window)
  (when window
    (setf *window-exceptions*
          (remove-if (lambda (x)
                       (string= (window-class window) x))
                     *window-exceptions*))))

(defcommand add-exception () ()
  (add-window-exception (current-window)))

(defcommand remove-exception () ()
  (remove-window-exception (current-window)))

;; add selective-name to format list and enable it
(push '(#\N selective-name) *window-formatters*)
(setf *window-format* "%n%s%N")


(toggle-mode-line (current-screen) (current-head))

;; make copy/paste work
;; THIS IS REALLY BROKEN FOR SOME REASON
(defparameter *copy-buffer* "")

(defcommand copy () ()
  (let ((sel (get-x-selection 1)))
    (when sel
      (setf *copy-buffer* sel))
    sel))

(defcommand paste () ()
  (window-send-string *copy-buffer*))

(define-key *top-map* (kbd "M-c") "copy")
(define-key *top-map* (kbd "M-v") "paste")

(defvar *purgatory* (gnewbg ".purgatory"))
(defvar *emacs* (gnewbg "emacs"))
(defvar *media* (gnewbg "media"))
(defvar *default* (current-group))

(defun run-or-toggle (cmd props &optional (home-group *purgatory*))
  (let ((win (current-window)))
    (if (and win (apply 'window-matches-properties-p win props))
	(move-window-to-group win home-group)
	(run-or-pull cmd props t t))))

(defun char-lower-p (char)
  (char= (char-downcase char) char))

(defun flip-char (char)
  (if (char-lower-p char)
      (char-upcase char)
      (char-downcase char)))

(defmacro defapp (name cmd props key &optional (home-group '*purgatory*))
  (let ((toggle (gensym)))
    `(progn
       (defcommand ,name (&optional ,toggle) (:string)
	 (if ,toggle
	     (run-or-toggle ,cmd ,props ,home-group)
	     (run-or-raise ,cmd ,props)))
       (define-key *top-map*
	   (kbd (format nil "H-~c" ,key))
	 (format nil "~a" ',name))
       (define-key *top-map*
           (kbd (format nil "H-~c" (flip-char ,key)))
           (format nil "~a t" ',name)))))

(defapp firefox "firefox" '(:class "Firefox") #\f *default*)
(defapp chrome "chrome" '(:class "Chromium-browser") #\g *default*)
(defapp irssi "xterm -e ssh -t glisp 'screen -rd;zsh -l'" '(:title "^irssi") #\i *default*)
(defapp my-emacs "xterm -e emacs" '(:title "emacs") #\e *emacs*)
(defapp vlc "vlc" '(:class "Vlc") #\v *media*)
(defapp rtorrent "xterm -e rtorrent" '( :title "rtorrent") #\r *default*)
(defapp htop "xterm -e htop" '(:title "htop") #\h *default*)

(defcommand pavucontrol () ()
  (run-or-toggle "pavucontrol" '(:class "Pavucontrol")))

(defcommand tux-commander () ()
  (run-or-toggle "tuxcmd" '(:class "Tuxcmd")))

(defcommand zsh () ()
  (run-or-raise "touch urself" '(:title "^zsh") nil nil))

(defcommand fuck () ()
  (run-shell-command "./fuck.sh"))

(define-key *top-map* (kbd "H-c") "tux-commander")
(define-key *top-map* (kbd "H-a") "pavucontrol")
(define-key *top-map* (kbd "H-f") "firefox")
(define-key *top-map* (kbd "H-t") *TERM*)
(define-key *top-map* (kbd "H-w") "where-is")
(define-key *top-map* (kbd "s-c") "colon")
(define-key *top-map* (kbd "s-x") "eval")
(define-key *top-map* (kbd "s-z") "exec")
(define-key *top-map* (kbd "s-r") "loadrc")
(define-key *top-map* (kbd "s-m") "mode-line")
(define-key *top-map* (kbd "H-z") "zsh")
(define-key *top-map* (kbd "s-g") '*groups-map*)
