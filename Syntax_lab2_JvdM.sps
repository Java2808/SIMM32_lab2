* Encoding: UTF-8.

*Recoded sex into dummy and recoded woman to female
  
  GET
  FILE='C:\Users\janet\OneDrive - Lund University\Courses\Quantitative methods\Multivariate\Databases\Lab2assigment.sav'.
DATASET NAME DataSet3 WINDOW=FRONT.
DATASET CLOSE DataSet2.
SORT CASES BY sex (A).
RECODE sex ('male'=0) ('female'=1) ('woman'=1) (MISSING=SYSMIS) INTO Sex_dummy.
EXECUTE.

*Descriptives

DESCRIPTIVES VARIABLES=pain age STAI_trait pain_cat cortisol_serum cortisol_saliva mindfulness
    sex_dummy
  /STATISTICS=MEAN STDDEV RANGE MIN MAX.

EXAMINE VARIABLES=pain age STAI_trait pain_cat cortisol_serum cortisol_saliva mindfulness sex_dummy
  /PLOT BOXPLOT STEMLEAF HISTOGRAM
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* Scatterplots Y with all the independent variables

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=age pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: age=col(source(s), name("age"))
  DATA: pain=col(source(s), name("pain"), unit.category())
  GUIDE: axis(dim(1), label("age"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of pain by age"))
  ELEMENT: point(position(age*pain))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=STAI_trait pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: STAI_trait=col(source(s), name("STAI_trait"))
  DATA: pain=col(source(s), name("pain"), unit.category())
  GUIDE: axis(dim(1), label("STAI_trait"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of pain by STAI_trait"))
  ELEMENT: point(position(STAI_trait*pain))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=pain_cat pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: pain_cat=col(source(s), name("pain_cat"))
  DATA: pain=col(source(s), name("pain"), unit.category())
  GUIDE: axis(dim(1), label("pain_cat"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of pain by pain_cat"))
  ELEMENT: point(position(pain_cat*pain))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=cortisol_saliva pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: cortisol_saliva=col(source(s), name("cortisol_saliva"))
  DATA: pain=col(source(s), name("pain"), unit.category())
  GUIDE: axis(dim(1), label("cortisol_saliva"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of pain by cortisol_saliva"))
  ELEMENT: point(position(cortisol_saliva*pain))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=cortisol_serum pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: cortisol_serum=col(source(s), name("cortisol_serum"))
  DATA: pain=col(source(s), name("pain"), unit.category())
  GUIDE: axis(dim(1), label("cortisol_serum"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of pain by cortisol_serum"))
  ELEMENT: point(position(cortisol_serum*pain))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mindfulness pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mindfulness=col(source(s), name("mindfulness"))
  DATA: pain=col(source(s), name("pain"), unit.category())
  GUIDE: axis(dim(1), label("mindfulness"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of pain by mindfulness"))
  ELEMENT: point(position(mindfulness*pain))
END GPL.

*First run of the regression model and check for extreme cases with high leverage

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT pain
  /METHOD=ENTER sex_dummy age
  /METHOD=ENTER STAI_trait pain_cat cortisol_serum cortisol_saliva mindfulness
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS DURBIN NORMPROB(ZRESID)
  /SAVE PRED COOK RESID.

* Plot Cook's distance

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=ID COO_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: ID=col(source(s), name("ID"), unit.category())
  DATA: COO_1=col(source(s), name("COO_1"))
  GUIDE: axis(dim(1), label("ID"))
  GUIDE: axis(dim(2), label("Cook's Distance"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of Cook's Distance by ID"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: point(position(ID*COO_1))
END GPL.

SORT CASES BY COO_1 (D).

* Skewness

EXAMINE VARIABLES=RES_1
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* Scatterplots for testing linearity

  
 GRAPH
  /SCATTERPLOT(BIVAR)=pain_cat WITH pain
  /MISSING=LISTWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=cortisol_serum WITH pain
  /MISSING=LISTWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=age WITH pain
  /MISSING=LISTWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=STAI_trait WITH pain
  /MISSING=LISTWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=mindfulness WITH pain
  /MISSING=LISTWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=sex_dummy WITH pain
  /MISSING=LISTWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=cortisol_saliva WITH pain
  /MISSING=LISTWISE.

* Testing for homoscedasticity

COMPUTE res_squared=RES_1 * RES_1.
EXECUTE.


DATASET ACTIVATE DataSet5.
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT res_squared
  /METHOD=ENTER sex_dummy age
  /METHOD=ENTER STAI_trait pain_cat cortisol_serum cortisol_saliva mindfulness
  /SCATTERPLOT=(*ZRESID ,*ZPRED).


* Running final model without cortison saliva


REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT pain
  /METHOD=ENTER sex_dummy age
  /METHOD=ENTER STAI_trait pain_cat mindfulness cortisol_serum
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID)
  /SAVE PRED COOK RESID.

EXAMINE VARIABLES=RES_2
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* AIC


REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA CHANGE SELECTION
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pain
  /METHOD=ENTER sex_dummy age
  /METHOD=ENTER STAI_trait pain_cat mindfulness cortisol_serum
  /SCATTERPLOT=(*ZRESID ,*ZPRED).

* Simple regression with only STAI as predictor

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT pain
  /METHOD=ENTER STAI_trait
  /SCATTERPLOT=(*ZRESID ,*ZPRED).

