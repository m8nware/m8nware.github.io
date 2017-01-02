(in-package #:m8n-site)
(named-readtables:in-readtable rutilsx-readtable)


(defmacro defpage (path (&key title style script bgimage)
                   &body body)
  `(with-out-file (out (system-relative-pathname
                        :m8n-site (fmt "static/~A.html" ,path)))
     (write-line
      (who:with-html-output-to-string (,(gensym))
        (:html
         (:head
          (:title ,title)
          (:link :rel "stylesheet" :type "text/css" :href "main.css")
          (:link :rel "stylesheet"
                 :href "https://fonts.googleapis.com/css?family=Merriweather")
          (when ',style
            (who:htm (:link :rel "stylesheet" :type "text/css"
                            :href (fmt "~A.css" ,style))))
          (when ',script
            (who:htm (:script :type "text/javascript"
                              :src (fmt "~A.js" ,script) ""))))
         (:body
          (:div :class "header" :style (fmt "background-image: url(~A.jpg)"
                                            ,bgimage)
                (:div :class "m8nware" (:a "(m8n)ware"))
                (:nav (:a ,@(if (string= "/" path)
                                '(:class "selected")
                                '(:href "/"))
                          "about")
                      (:a ,@(if (starts-with "/team" path)
                                '(:class "selected")
                                '(:href "/news"))
                          "news")
                      (:a ,@(if (starts-with "/team" path)
                                '(:class "selected")
                                '(:href "/team"))
                          "team")))
          (:div :class "body"
                (who:str ,@body))
          (:hr :width "300")
          (:div :class "footer"
                (:span :class "tagline"
                       (who:fmt "~A (m8n) हरे कृष्ण"
                                (nth-value 5 (decode-universal-time
                                              (get-universal-time)))))))))
      out)))

(defun md->html (file)
  (with-output-to-string (out)
    (3bmd:parse-string-and-print-to-stream
     (read-file (system-relative-pathname :m8n-site (fmt "txt/~A.md" file)))
     out)))

(defpage "index" (:title "(m8n)ware" :bgimage "sea")
  (md->html "about"))

(defpage "news" (:title "(m8n)ware news" :bgimage "pond")
  (md->html "news"))

(defpage "team" (:title "(m8n)ware team" :bgimage "stars")
  (md->html "team"))
