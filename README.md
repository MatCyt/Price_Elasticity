# Price_Elasticity_R
Calculating regular and cross price elasticity for products based on weekly sales data

### DATA REQUIREMENTS
You can find a sample of the data (based on real sales dataset of small company).
Typically offline sales for FMCG market will be reported on a weekly level.
However to run a study like this you will need dataset containing price and sales in time for a given SKU.
That is enough for a baseline.

Sales can be expressed in volume, value or units. Choosing the metric depends mostly on the ease of interpretation and business goals.

The more variables describing sales you will add to the regression model, the more reliable your price elasticity study will be.

To calculate cross price elasticities you will obviously need price points of other products (same manufacturer or of competitors).

Knowing the regular and promo price will enable splitting the PE into two metrics bringing much more insights - described in the end

### Overview
Aim of the pricing studies - learn about past impact of the price on sales and try to adjust future actions.
Price elasticity is one of the basic metrics to achieve this - but since you are on this page you most likely know it.

To be on the same page - price elasticity is the measurement of price impact on sales. Simply speaking it is a value describing by how much percent your sales will change if you will increase your price by 1%. Price elasticity of -2 means that by increasing the price by one percent we will loose two percent in sales.
It is defined by this formula:
PRICE ELASTICITY FORMULA

In broad and full price study (done by companies like Nielsen) deliver more outputs than just this one metric.
We could have few main outputs here:
1) Descriptive pricing overview
Price trend - showing how the price varied across different products in a given time (any deep discounts? big price changes?)
Price architecture - showing the variance of price across each SKU. This could be replaced by showing the regular, promo and average price if those values are known
2) Regular / Own price elasticity - own price elasticity of a given product
3) Cross price elasticity - impact of price of different products on each other's sales.
4) Promo price vs regular price elasticity - good indicator of future price policy, discussed at the end


#### WHEN TO CALCULATE IT
Besides the regression significance output for a given variable we could in advance try to predict if given product is a good candidate for such study.
It should have a stable distribution over time, at least ~30 weeks of constant sales. Otherwise we just don't have enough observations.
It should also have some variance in price over time. If the price was stable over past two years we won't be able to see any impact of changes on sales. There was simply no changes.

#### LIMITATIONS
Due to limitations of regressions itself, price elasticity should not be treated in my opinion as a metric used to calculate exact price point for a given product or used for sales similation. In most cases, as you will see in the results below, the regression coefficients values are just too unstable to treat this output as a sacred truth.
Seeing values of -5 for one product and -0.5 for the other we should not be tempted to predict their exact sales.
However with good overal quality of the model they can be a good way to identify products that could potentially benefit from discounts (-5) or could consider small price increase if necessary (-0.5).
If we will keep the limitations in mind it could serve as a good insight to understand price sensitivity of our customers across different products or brands or to see how we are impacted by pricing of other products.



### Descriptive
Code for all of the visualizations can be found in script INSERT NAME HERE
#### Price trend
This simple graph shows us what happened with pricing of listed products over time. We can see different price levels of SKUs
COLORS
and price changes WHICH SKU

INSERT GRAPH HERE

#### Price architecture
here we can easily see the variance in price for a given sku over time
this could also be replaced by promo price, regular price and average price

INSERT GRAPH HERE

### Own price elasticity
The main poins are relatively simple. We run linear regression for each of the products, taking the sales and price over time as minimum input. Data sample can be found in the folder above. Function to run the lm for all SKUs in the typical sales csv file is shown below and in the r script above.
Adding more variables impacting sales is more than great idea. Media spending, distribution, promotions, seasonal events. Bring them all in. They will only help your models and metrics. 

INSERT CODE

The price elasticity calculation is DEFINITION
CODE EXAMPLE

Here we can see the output results. As mentioned before - depending of the model quality this should not be treated as a literal value of what will happen to our sales but they are a good indicator of price sensitive products

INSERT CHART

### Cross price elasticity
What is cross price elascitity
It can be helpful because you will see not only a own impact but how others impact your sales and how your pricing decisions impact other products. It is necessary to understand when you are stealing from your competitors and when you are cannibalizing your other products. And which exact products of your competitors you should observe closely

This is a code to run the model for all possible combination and print ready outpu

INSERT CODE

CHART DESCRIPTION 
Rows vs columns, how to interpret it

INSERT CHART


### Promo vs regular 
Missing and potential variables - promo price (what was it during discounts) vs regular (like here)
We could break products into four groups identifying different pricing strategies

DESCRIBE GROUPS

### Materials
Here you can find some links and materials I found usefull along the way:

Code | Baseline - simple step by step price elasticity calculation with R:
http://www.salemmarafi.com/code/price-elasticity-with-r/

Code | Price elasticity in R with non-linear relations included:
https://www.r-bloggers.com/food-for-regression-using-sales-data-to-identify-price-elasticity/

Theory | Price elasticity limitations and things to keep in mind during interpretation:
http://www.cornerstonecapabilities.com/what-you-must-know-about-pricing-elasticity-and-the-danger-it-may-bring/

Theory | Cross price elasticity and cannibalization
https://www.ashokcharan.com/Marketing-Analytics/~pm-cannibalization.php

Longer theory | Whole chapter on pricing studies and different method / models:
https://www.ashokcharan.com/Marketing-Analytics/~pr-what-price.php
