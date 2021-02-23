*1
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear

*3
gen DUI = (bac1>=0.08)

*4
histogram bac1, discrete width(0.001) fcolor(%80) lcolor(none) xline(0.08) frequency xtitle("BAC ") title("BAC Distribution")
graph export "C:\Users\omasa\Documents\GitHub\RDD\writing\figure\hist.png", replace

*5
gen BAC = bac1 - 0.08

export delimited using data\hansen.csv, replace

eststo clear

eststo Male: reg male c.BAC##i.DUI if bac1>=0.03 & bac1<=0.13, cluster(BAC)
estadd scalar mean = _b[BAC]*(-0.001)+_b[_cons]
estadd local controls "No"
eststo White: reg white c.BAC##i.DUI if bac1>=0.03 & bac1<=0.13, cluster(BAC)
estadd scalar mean = _b[BAC]*(-0.001)+_b[_cons]
estadd local controls "No"
eststo Age: reg age c.BAC##i.DUI if bac1>=0.03 & bac1<=0.13, cluster(BAC)
estadd scalar mean = _b[BAC]*(-0.001)+_b[_cons]
estadd local controls "No"
eststo ACC: reg acc c.BAC##i.DUI if bac1>=0.03 & bac1<=0.13, cluster(BAC)
estadd scalar mean = _b[BAC]*(-0.001)+_b[_cons]
estadd local controls "No"

esttab using C:\Users\omasa\Documents\GitHub\RDD\writing\table\table2.tex, replace booktabs width(0.7\hsize) mgroups("Driver demographic characteristics", pattern(1 0 0 1) prefix(\multicolumn{@span}{c}{)suffix(}) span erepeat(\cmidrule(lr){2-4})) b(3) se star not drop(BAC 0.DUI 0.DUI#c.BAC 1.DUI#c.BAC _cons) stats(mean controls N, labels("Mean (at 0.079)" Controls Observations) fmt(%4.3f %8.0gc)) rename(1.DUI DUI) varwidth(15) collabels(none) mtitles("Male" "White" "Age" "Accident") addnotes("Note: All regressions have a bandwidth of 0.05.") starlevels( * 0.10 ** 0.05 *** 0.010)  prefoot("")



*6
** Linear Trend
cmogram acc bac1 if bac1>=0.03 & bac1<=0.15, cut(0.08) scatter line(0.08) lfitci histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\acc_l.png") legend graphopts(legend(order(1 4 3) label(1 "Accident") rows(1)) color(gray)) title("Linear Fit")
cmogram male bac1 if bac1>=0.03 & bac1<=0.15, cut(0.08) scatter line(0.08) lfitci histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\male_l.png") legend graphopts(legend(order(1 4 3) label(1 "Male") rows(1)) color(gray)) title("Linear Fit")
cmogram age bac1 if bac1>=0.03 & bac1<=0.15, cut(0.08) scatter line(0.08) lfitci histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\age_l.png") legend graphopts(legend(order(1 4 3) label(1 "Age") rows(1)) color(gray)) title("Linear Fit")
cmogram white bac1 if bac1>=0.03 & bac1<=0.15, cut(0.08) scatter line(0.08) lfitci  histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\white_l.png") legend graphopts(legend(order(1 4 3) label(1 "White") rows(1)) color(gray)) title("Linear Fit")


** Quadratic Trend
cmogram acc bac1 if bac1>=0.03 & bac1<=0.15, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\acc_q.png") legend graphopts(legend(order(1 4 3) label(1 "Accident") rows(1)) color(gray)) title("Quadratic Fit")
cmogram male bac1 if bac1>=0.03 & bac1<=0.15, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\male_q.png") legend graphopts(legend(order(1 4 3) label(1 "Male") rows(1)) color(gray)) title("Quadratic Fit")
cmogram age bac1 if bac1>=0.03 & bac1<=0.15, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\age_q.png") legend graphopts(legend(order(1 4 3) label(1 "Age") rows(1)) color(gray)) title("Quadratic Fit")
cmogram white bac1 if bac1>=0.03 & bac1<=0.15, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\white_q.png")legend graphopts(legend(order(1 4 3) label(1 "White") rows(1)) color(gray)) title("Quadratic Fit")


*7
** Panel A
eststo clear

eststo: reg recidivism male white aged BAC i.DUI i.year if bac1>=0.03 & bac1<=0.13, cluster(BAC)
predict y_hat1
estadd scalar mean = y_hat1
eststo: reg recidivism male white aged c.BAC##i.DUI i.year if bac1>=0.03 & bac1<=0.13, cluster(BAC)
predict y_hat2
estadd scalar mean = y_hat2
gen BAC2 = BAC*BAC
eststo: reg recidivism male white aged (c.BAC c.BAC2)##i.DUI i.year if bac1>=0.03 & bac1<=0.13, cluster(BAC)
predict y_hat3
estadd scalar mean = y_hat3

esttab using C:\Users\omasa\Documents\GitHub\RDD\writing\table\table3A.tex, indicate(Controls = male white aged) replace booktabs width(0.7\hsize) b(3) se star not drop(*.year BAC BAC2 0.DUI 0.DUI#c.BAC 0.DUI#c.BAC2 1.DUI#c.BAC 1.DUI#c.BAC2 _cons) stats(mean N, labels("Mean" Observations) fmt(%4.3f %8.0gc)) rename(1.DUI DUI) varwidth(15) collabels(none) refcat(DUI "\textit{Panel A: BAC} $\in$ [0.03, 0.13]", nolabel) mtitles("(1)" "(2)" "(3)") nonumbers starlevels( * 0.10 ** 0.05 *** 0.010) postfoot(\end{tabular*}}) prefoot("")

** Panel B
drop(y_hat1 y_hat2 y_hat3)
eststo clear

eststo: reg recidivism male white aged BAC i.DUI i.year if bac1>=0.055 & bac1<=0.105, cluster(BAC)
predict y_hat1
estadd scalar mean = y_hat1
eststo: reg recidivism male white aged c.BAC##i.DUI i.year if bac1>=0.055 & bac1<=0.105, cluster(BAC)
predict y_hat2
estadd scalar mean = y_hat2
eststo: reg recidivism male white aged (c.BAC c.BAC2)##i.DUI i.year if bac1>=0.055 & bac1<=0.105, cluster(BAC)
predict y_hat3
estadd scalar mean = y_hat3

esttab using C:\Users\omasa\Documents\GitHub\RDD\writing\table\table3.tex, indicate(Controls = male white aged) replace booktabs width(0.7\hsize) b(3) se star not drop(*.year BAC BAC2 0.DUI 0.DUI#c.BAC 0.DUI#c.BAC2 1.DUI#c.BAC 1.DUI#c.BAC2 _cons) stats(mean N, labels("Mean" Observations) fmt(%4.3f %8.0gc)) rename(1.DUI DUI) varwidth(15) collabels(none) refcat(DUI "\textit{Panel B: BAC} $\in$ [0.055, 0.105]", nolabel) mtitles("(1)" "(2)" "(3)") nonumbers topfile(C:\Users\omasa\Documents\GitHub\RDD\writing\table\table3A.tex) mlabels(none) starlevels( * 0.10 ** 0.05 *** 0.010) prehead({\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular*}{0.7\hsize}{@{\hskip\tabcolsep\extracolsep\fill}l*{3}{c}}) posthead("") prefoot("")

*8
** 1
cmogram recidivism bac1 if bac1>=0.03 & bac1<=0.15, cut(0.08) scatter line(0.08) lfitci histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\recid_l.png") legend graphopts(legend(order(1 4 3) label(1 "Recidivism") rows(1)) color(gray)) title("Recidivism: Linear Fit")
** 2
cmogram recidivism bac1 if bac1>=0.03 & bac1<=0.2, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) saving("C:\Users\omasa\Documents\GitHub\RDD\writing\figure\recid_q.png") legend graphopts(legend(order(1 4 3) label(1 "Recidivism") rows(1)) color(gray)) title("Recidivism: Quadratic Fit")