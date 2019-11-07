# Pricing Exploration and Visualization


# LOAD LIBRARIES ----------------------------------------------------------
library(tidyverse)

# LOAD DATASETS -----------------------------------------------------------
df_sales = read_csv('./data/dummy_sales.csv') %>%
  select(-X1)

df_ope = read_csv('./data/own_price_elasticity.csv')

df_cpe = read_csv('./data/cross_price_elasticity')

# DESCRIPTIVE PRICING VISUALIZATION -----------------------------------------------------

# Dataset prep
df_prices_ACK = df_sales %>%
  filter(SKU == 'SKU_A' | SKU == 'SKU_C' | SKU == 'SKU_K')

df_prices_DJ = df_sales %>%
  filter(SKU == 'SKU_D' | SKU == 'SKU_J')

df_prices_FBIH = df_sales %>%
  filter(SKU == 'SKU_F' | SKU == 'SKU_B' | SKU == 'SKU_I' | SKU == 'SKU_H')

df_prices_G = df_sales %>%
  filter(SKU == 'SKU_G')


# Plots prep

plot_price_trend_ACK = ggplot(df_prices_ACK, aes(x = SalesDate, y = average_price, group = SKU)) + 
  geom_line(aes(color = SKU), size = 1) +
  theme_minimal()

plot_price_trend_DJ = ggplot(df_prices_DJ, aes(x = SalesDate, y = average_price, group = SKU)) + 
  geom_line(aes(color = SKU), size = 1) +
  theme_minimal()

plot_price_trend_FBIH = ggplot(df_prices_FBIH, aes(x = SalesDate, y = average_price, group = SKU)) + 
  geom_line(aes(color = SKU), size = 1) +
  theme_minimal()

plot_price_trend_G = ggplot(df_prices_G, aes(x = SalesDate, y = average_price, group = SKU)) + 
  geom_line(aes(color = SKU), size = 1) +
  theme_minimal()


# Plots print

par(mfrow=c(3,1))

plot_price_trend

dev.off()



# REGULAR PRICE ELASTICITY VISUALIZATION ----------------------------------





# CROSS PRICE ELASTICITY VISUALIZATION ------------------------------------



test = df_sales %>%
  filter(SKU == 'SKU_G')

View(test)
