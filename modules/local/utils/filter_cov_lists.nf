//    grep -F ">" ${prefix}.contigs.fa | sed -e 's/_/ /g' | sort -nrk 6 | awk '${task.ext.args_lcov} {print \$0}'  | sed -e 's/ /_/g'| sed -e 's/>//g' > ${prefix}.LCov.contigs.list
//    grep -F ">" ${prefix}.contigs.fa |  sed -e 's/_/ /g' | sort -nrk 6 | awk '${task.ext.args_hcov} {print \$0}' | sed -e 's/ /_/g'| sed -e 's/>//g' > ${prefix}.HCov.contigs.list


