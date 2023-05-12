library(plotly)
library(ggplot2)
library(worldriskpollr)

# Retrieve globally aggregated data on levels of worry of violent crime
worry <- wrp_get(geography = "world", 
                 wrp_question_uid = "Q4C", disaggregation = 0) %>%
  filter(response == "Very worried") %>%
  group_by(geography, year, question) %>% 
  summarise(percentage = sum(percentage)) %>%
  ungroup() %>%
  mutate(short_question = "Worry about Violent Crime")

# Retrieve globally aggregated data on levels of experience on violent crime
personal_experience <- wrp_get(geography = "world", 
                      wrp_question_uid = "Q5C",
                      disaggregation = 0) %>%
  filter(response %in% c("Yes, personally experienced",
                         "Both")) %>%
  group_by(geography, year, question) %>% 
  summarise(percentage = sum(percentage)) %>%
  ungroup() %>%
  mutate(short_question = "Personal Experience of Violent Crime")
           

# Make data frames include the same years
worry <- worry %>% filter(year %in% personal_experience$year)
# combine data frames for plotting
worry_personal_experience <- worry %>% rbind(personal_experience)       


p=ggplot(worry_personal_experience, aes(x = short_question, y = percentage/100)) + 
  geom_bar(stat = "identity", fill = "cornflowerblue") + 
  theme_minimal() +
  labs(x = "", 
       y = "Percentage of Global Population", 
       caption = "SOURCE: Lloyd's Register Foundation World Risk Poll") +
  scale_y_continuous(labels = scales::percent)
ggsave(p, filename = "fig-1.png")