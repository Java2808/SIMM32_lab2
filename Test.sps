* Encoding: UTF-8.



* Chart Builder.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=sqft_living price MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: sqft_living=col(source(s), name("sqft_living"))
  DATA: price=col(source(s), name("price"))
  GUIDE: axis(dim(1), label("sqft_living"))
  GUIDE: axis(dim(2), label("price"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of price by sqft_living"))
  ELEMENT: point(position(sqft_living*price))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=grade price MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: grade=col(source(s), name("grade"))
  DATA: price=col(source(s), name("price"))
  GUIDE: axis(dim(1), label("grade"))
  GUIDE: axis(dim(2), label("price"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of price by grade"))
  ELEMENT: point(position(grade*price))
END GPL.

* Chart Builder.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=id price COO_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=YES SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: id=col(source(s), name("id"))
  DATA: price=col(source(s), name("price"))
  DATA: COO_1=col(source(s), name("COO_1"))
  GUIDE: axis(dim(1), label("id"))
  GUIDE: axis(dim(2), label("price"))
  GUIDE: text.title(label("Simple Scatter with Fit Line of price,  of Cook's Distance by id"))
  TRANS: id_price=eval("id - price")
  TRANS: id_COO_1=eval("id - Cook's Distance")
  ELEMENT: point(position(id*price), color.interior(id_price))
  ELEMENT: point(position(id*COO_1), color.interior(id_COO_1))
END GPL.

GGRAPH 
  /GRAPHDATASET NAME="graphdataset" VARIABLES=sqft_living price MISSING=LISTWISE REPORTMISSING=NO 
  /GRAPHSPEC SOURCE=INLINE. 
BEGIN GPL 
  SOURCE: s=userSource(id("graphdataset")) 
  DATA: sqft_living=col(source(s), name("sqft_living")) 
  DATA: price=col(source(s), name("price")) 
  GUIDE: axis(dim(1), label("sqft_living")) 
  GUIDE: axis(dim(2), label("price")) 
  ELEMENT: point(position(sqft_living*price)) 
  ELEMENT: line(position(smooth.linear(sqft_living*price)))
END GPL.

