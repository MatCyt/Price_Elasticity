# Calculating Cross Price Elasticity for any given SKU



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

sku_list = unique(df_base$SKU)


# RUN MODELS FOR EACH COMBINATION OF SKUs ---------------------------------
# Store the results in a list and add a new table to gather final metrics

# Create new table to be used later for price elasticity calculation
additional_metrics = df_base %>%
  group_by(SKU) %>%
  summarise(mean_sales = mean(sum_units),
            mean_price = mean(average_price))

models = list()
model_names = list()
cross_results = data.frame()

# Run a model for each SKU

for (sku in sku_list) {
  
  target_variable = paste('sum_units', sku, sep = '_') # select target - here we model on units
  
  input = df_casted %>% # keep sales of sku as target and price of all other skus as other variables
    select(str_subset(names(df_casted), 'average_price'), target_variable) 
  
  model_name = paste(sku, 'model' ,sep = '_') 
  
  model_iterated = lm( # run models on all skus
    as.formula(paste(target_variable, 
                     "~ .")) 
    , data = input)
  
  
  ### Build end output and add line by line to final data frame with results
  
  # Extract model metrics and transform into desired format
  model_output = as.data.table(summary(model_iterated)$coefficients) %>%
    mutate(variables = rownames(summary(model_iterated)$coefficients)) %>%
    select(c(1,4,5)) %>%
    rename(p_value = 2) %>%
    filter(variables != '(Intercept)')

  # Calculate price elasticities - use price and sales from additional metrics by joining the tables
  elasticity_input = model_output %>%
    mutate(model = model_name,
           SKU = sub("^[^_]*_[^_]*_", "", variables)) %>%
    left_join(additional_metrics) %>%
    mutate(elasticity = Estimate * (mean_price / mean_sales),
           significant = ifelse(p_value < 0.2, 'significant', 'not significant'),
           own_price = ifelse(SKU == sku, 'yes', 'no')) %>%
    arrange(desc(variables)) %>% 
    # Add information about significance for each SKU (separately for cross and own) - see Readme for this point discussion
    # Change the elasticity value to 0 for each not significant variable
    mutate(elasticity = replace(elasticity, 
                                own_price == 'no' & (significant == 'not significant' | Estimate < 0), 0),
           elasticity = replace(elasticity,
                                own_price == 'yes' & (significant == 'not significant' | Estimate > 0), 0))
  
  elasticity_output = dcast(elasticity_input, model ~ variables, value.var = 'elasticity')
  
  # Add the results from the model to the final table
  cross_results = rbind(cross_results, elasticity_output)
  
}

# nearly final result
cross_results


# SET SAME ORDER OF COLUMNS AND ROWS --------------------------------------
# to read the output easier

# change the naming order to facilitate arrangement of columns
colnames(cross_results)[2:length(colnames(cross_results))] = paste(sub("^[^_]*_[^_]*_", "", colnames(cross_results)), 'average_price', sep = '_')

# transform into final format
cross_results = cross_results %>%
  arrange(model) %>%
  select(sort(names(.))) %>%
  select(model, ends_with('price')) %>%
  select(-model_average_price)

# final output
cross_results

# Save the output
# write.csv(cross_results, 'cross_price_elasticity.csv')
