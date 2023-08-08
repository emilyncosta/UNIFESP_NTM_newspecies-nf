#!/usr/bin/env bb

(require '[babashka.cli :as cli]
         '[babashka.fs :as fs]
         '[clojure.string :as cstr]
         '[clojure.java.io :as io]
         '[clojure.java.shell :as shell]
         '[clojure.data.csv :as csv])

;;================================================
;; Core logic
;;================================================


(defn- read-orthoani-results [input-file]
  (with-open [reader (io/reader (io/file input-file))]
    (doall (->> reader
                line-seq))))


(defn transform-orthoani-results [input-file]
   (let [result (read-orthoani-results input-file)
        similarity (nth result 0)
        ratio  (-> (second (cstr/split similarity #":"))
                   (cstr/split #"\ ")
                   second)
        fasta1 (nth result 1)
        fasta2 (nth result 2)]
    (doall
     (str fasta1 "," fasta2 ","  ratio))))


(defn transform-orthoani-folder [input-folder]
  (->  (mapv
        (fn [a-file-name]
          (transform-orthoani-results (str input-folder "/" a-file-name)))

        (-> (shell/sh "ls" input-folder)
            :out
            (cstr/split  #"\n")))
       sort))


;;================================================
;; DRIVER Code
;;================================================


(defn write-transformed-csv [{:keys [input-folder output-file]}]
  (let [csv-list (transform-orthoani-folder input-folder)
        csv-string (doall (str (reduce (fn [x y] (str x "\n" y)) csv-list) "\n"))]

    (with-open [w (io/writer output-file)]
      (spit w csv-string))))



;;================================================
;; CLI
;;================================================

(def write-transformed-csv-cli-opts
  {:input-folder     {:desc    "Input folder with OrthoANI results"
               :alias :i}
   :output-file    {:desc    "Output CSV file"
               :alias :o}
   })



(defn help
  [_]
  (println
   (str "A utility script to combine the results of orthoANI\n"
        "csv\n"
        (cli/format-opts {:spec write-transformed-csv-cli-opts}))))

(def cli-args
  [{:cmds ["csv"]
    :fn  #(write-transformed-csv (:opts %))
    :spec write-transformed-csv-cli-opts
    :args->opts [:cluster-file]}

   {:cmds [] :fn help}])

(cli/dispatch cli-args *command-line-args* {:coerce {:depth :long}})
