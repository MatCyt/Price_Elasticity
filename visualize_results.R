# Pricing Exploration and Visualization


# LOAD LIBRARIES ----------------------------------------------------------
library(tidyverse)
library(gridExtra)
library(scales)
library(ggsci)
library(reshape2)
library(kableExtra)

# LOAD DATASETS -----------------------------------------------------------
df_sales = read_csv('./data/dummy_sales.csv') %>%
  select(-X1)

df_ope = read_csv('./data/own_price_elasticity.csv')

df_cpe = read_csv('./data/cross_price_elasticity.csv') %>%
  select(-X1)

# PRICE TRENDS -----------------------------------------------------

# Dataset prep
df_sales = df_sales %>%
  mutate(SalesDate = as.Date(SalesDate, "%d/%m/%Y"))

df_prices_ACK = df_sales %>%
  filter(SKU == 'SKU_A' | SKU == 'SKU_C' | SKU == 'SKU_K')

df_prices_DJ = df_sales %>%
  filter(SKU == 'SKU_D' | SKU == 'SKU_J')

df_prices_FBIH = df_sales %>%
  filter(SKU == 'SKU_F' | SKU == 'SKU_B' | SKU == 'SKU_I' | SKU == 'SKU_H')

df_prices_G = df_sales %>%
  filter(SKU == 'SKU_G')

# Plots prep

p_pricetrend = ggplot(df_sales, aes(x = SalesDate, y = average_price, group = SKU)) + 
  geom_line(aes(color = SKU), size = 1) +
  theme_minimal() +
  ylim(0, 8) +
  scale_x_date(date_breaks = "6 months") +
  scale_color_manual(breaks = c("SKU_H", "SKU_G", "SKU_I", "SKU_F", "SKU_B", "SKU_J", "SKU_D", "SKU_C", "SKU_K", "SKU_A"),
                     values=c("#F28F17", "#4A88E9", "#F2D417", "#00AB9B", "#00ADFB", 
                              '#E33842', "#955EA8", "#00ADFB", '#4CF470', '#C2C964')) +
  labs(title = 'Price trends')

p_pricetrend

# dev.off()


# PRICE ARCHITECTURE ------------------------------------------------------

df_pricestr = df_sales %>%
  group_by(SKU) %>%
  summarise(min_price = min(average_price),
            mean_price = mean(average_price),
            max_price = max(average_price))


df_pricestr_l = melt(df_pricestr, id = 'SKU')

p_price_arch = ggplot(df_pricestr_l, aes(x = SKU, y = value, group = variable)) +
  geom_point(aes(color = variable), size = 5, shape = 15) +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  scale_color_npg(breaks=c("max_price","mean_price","min_price")) +
  labs(title = 'Price Architecture',
       x = "",
       y = 'Price Structure') +
  geom_text(aes(label=round(value, 2)),hjust=-0.3, vjust=-1)

p_price_arch


# OWN (REGULAR) PRICE ELASTICITY VISUALIZATION ----------------------------------

# filter out only significant variables
df_ope2 = df_ope %>%
  filter(significance == 'significant') %>%
  mutate(category=cut(price_elasticity, breaks=c(0, -1.2, -2, -5, -Inf), labels=c("very high","high","middle", "low")),
         SKU = sub("^[^_]*_", "", model)) %>%
  select(SKU, price_elasticity, category) %>%
  arrange(desc(price_elasticity))

# plot
p_ope = ggplot(df_ope2, aes(x = reorder(SKU, -price_elasticity), y = price_elasticity, fill = category)) + 
  geom_bar(stat = 'identity', width = 0.5) +
  scale_fill_manual(values=c('#C34A36', # very high
                             "#FF8066", # high
                             "#FFC75F", # middle
                             "#9DD694")) +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 10),
        legend.text = element_text(size = 10)) +
  labs(title = 'Regular Price Elasticity',
       x = "",
       y = 'Price Elasticity') +
  scale_x_discrete(position = "top") +
  scale_y_continuous(expand = c(0,0)) +
  geom_text(aes(label=round(price_elasticity,1)),position=position_stack(vjust=0.5), size = 5)

p_ope

# CROSS PRICE ELASTICITY VISUALIZATION ------------------------------------
df_cpe2 = df_cpe %>%
  mutate_if(is.numeric, round, 2) %>%
  mutate(SKU = str_sub(model_price, 1, 5)) %>%
  select(-model_price) %>%
  select(SKU, everything()) 

df_cpe2 %>%
  kable() %>%
  kable_styling(bootstrap_options = c("striped", "condensed"), 
                full_width = F,
                font_size = 20)

formattable(df_cpe2)

# write.csv(df_cpe2, './data/cross_price_elasticity_output.csv', row.names = F)
