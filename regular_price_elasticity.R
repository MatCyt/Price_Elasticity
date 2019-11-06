# Calculating Regular (Own) Price Elasticity for any given SKU



### LOAD LIBRARIES ----------------------------------------------
pacman::p_load(tidyverse, data.table)



### LOAD DATA ----------------------------------------------

# For a simple case scenario only two variables are important: price and sales (in value, units and volume depending on goal)
# In a real world we should include all possible variables impacting sales (distribution, advertising, competitors actions etc.)

df_base = read_delim('./data/dummy_sales.csv', delim = ',') %>%
  mutate(X1 = NULL)

# Dataset represents sales (in value and units) and average price for 8 SKUs across 156 weeks
# while it is not a real dataset it is very closely based on one

str(df_base) 
length(unique(df_base$SalesDate))
length(unique(df_base$SKU)) 



### CAST DATA ----------------------------------------------
# we need to dcast/pivot data to change it into model appropriate format
df_casted = dcast(setDT(df_base), SalesDate ~ SKU, value.var = c('sum_value', 'sum_units', 'average_price'))



### RUN LINEAR MODELS TO EXTRACT PRICING COEFFICIENTS ----------------------------------------------
# To calculate price elasticities we will run a linear model for every SKU and store the results in properly named list
# You need to decide what you will treat as target variable - value? units? volume?
# Depends most likely on the business goal or logic behind the study

sku_list = unique(df_base$SKU)

# initiate empty lists to store the models and their names
models = list() 
model_names = list()

# initiate empty data_frame to store the models results
models_results = data.frame(model = NULL, 
                            price_p_value = NULL,
                            price_coef = NULL,
                            mean_price = NULL,
                            mean_sales = NULL)



# Run the model for each SKU in data frame
for (i in sku_list) {
  
  # select columns only for one SKU in that iteration
  input = df_casted %>%
    select(str_subset(names(df_casted), i)) 
  
  
  # create model name and add it to the list to be used later
  model_name = paste('model', i, sep = '_')
  model_names = c(model_names, list(model_name))
  
  
  # run model for given SKU
  model_iterated = lm(
    as.formula(paste(colnames(input)[2], # 1 for value, 2 for units
                     "~", paste(colnames(input)[3]))) # 3rd column for price
    , data = input)
  
  
  # Add model object to the list and change the naming
  models = c(models, list(model_iterated))
  

  # store the p value of the regular price for model validation
  models_results[ i, 'model'] = model_name
  models_results[ i, 'price_p_value'] = round(summary(model_iterated)$coefficients[8],6)
  models_results[ i, 'price_coef'] = summary(model_iterated)$coefficients[2]
  models_results[ i, 'mean_price'] = mean(input[[3]])
  models_results[ i, 'mean_sales'] = mean(input[[2]])
  
}

# change the naming within the list
names(models) = model_names

# we end up with the list of all the models results and a table summarizing all of them
summary(models)
models_results



#### CALCULATE PRICE ELASTICITY ----------------------------------------------
# Calculate the price elasticity value 
# Mark the results as significant with cutoff on p value at 0.2

df_own_price_elasticity = models_results %>%
  mutate(price_elasticity = price_coef * (mean_price / mean_sales),
         significance = ifelse(price_p_value < 0.2, 'significant', 'not significant')) %>% # TODO properly adjust the condition here
  arrange(desc(mean_sales))

# final output
df_own_price_elasticity

# save the output
# write_csv(df_own_price_elasticity, './data/own_price_elasticity.csv')
