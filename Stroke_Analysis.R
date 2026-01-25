#installing packages
install.packages(c("readxl", "dplyr", "ggplot2", "janitor"))
install.packages(c("broom","forcats"))
#loading libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(janitor)
library(broom)
library(forcats)

#loading the data
stroke_data<-read_excel("C:/Users/Hp/OneDrive/Clean_stroke_data.xlsx",sheet =2 )
#Viewing the data
View(stroke_data)

#Checking the structure of the data
str(stroke_data)
summary(stroke_data)
nrow(stroke_data)
glimpse(stroke_data)

#Removing excel helper rows and cleaning column names
library(dplyr)


stroke_df <- stroke_data %>%
  select(
    id,
    gender,
    age_clean,
    age_group,
    hypertension,
    heart_disease,
    ever_married,
    work_type,
    Residence_type,
    avg_glucose_clean,
    bmi,
    bmi_clean,
    smoking_status_clean,
    stroke ## target variables
  )

#Converting bmi to numeric
stroke_df <- stroke_df %>%
  mutate(bmi_num = as.numeric(bmi))
summary(stroke_df$bmi_num)

#Converting categorical variables to factors
stroke_df <- stroke_df %>%
  mutate(
    gender = as.factor(gender),
    age_group = as.factor(age_group),
    hypertension = as.factor(hypertension),
    heart_disease = as.factor(heart_disease),
    ever_married = as.factor(ever_married),
    work_type = as.factor(work_type),
    Residence_type = as.factor(Residence_type),
    bmi_clean = as.factor(bmi_clean),
    smoking_status_clean = as.factor(smoking_status_clean)
  )

#Checking the structure after transformation
str(stroke_df)
summary(stroke_df)

#Creating binary target for modeling
stroke_df <- stroke_df %>%
  mutate(stroke_bin = stroke)
summary(stroke_df$stroke_bin)

#Exploratory Data Analysis(EDA)
prop.table(table(stroke_df$stroke)) * 100

#Stroke by age group
table(stroke_df$age_group, stroke_df$stroke)

#stroke by gender
table(stroke_df$gender, stroke_df$stroke)

#stroke by bmi
table(stroke_df$bmi_clean, stroke_df$stroke)

#Stroke by smoking status
table(stroke_df$smoking_status_clean, stroke_df$stroke)

#VISUALIZATION of the EDA's above
library(ggplot2)

#Changing back to categorical just to add colour
unique(stroke_df$stroke)
stroke_df$stroke <- factor(
  stroke_df$stroke,
  levels = c(0, 1),
  labels = c("No", "Yes")
)
stroke_colors <- c("No" = "#1F77B4", "Yes" = "#D62728")
#Stroke distribution
ggplot(stroke_df, aes(x = stroke, fill = stroke)) +
  geom_bar() +
  scale_fill_manual(values = stroke_colors) +
  labs(
    title = "Distribution of Stroke Cases",
    subtitle = "Comparison of patients with and without stroke",
    x = "Stroke Status",
    y = "Number of Patients",
    fill = "Stroke"
  ) +
  theme_minimal()

#Stroke by Age group
ggplot(stroke_df, aes(x = age_group, fill = stroke)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = stroke_colors) +
  labs(
    title = "Stroke Occurrence by Age Group",
    subtitle = "Stroke cases increase with age",
    x = "Age Group",
    y = "Number of Patients",
    fill = "Stroke Status"
  ) +
  theme_minimal()
#Stroke by bmi category
ggplot(stroke_df, aes(x = bmi_clean, fill = stroke)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = stroke_colors) +
  labs(
    title = "Stroke Occurrence by BMI Category",
    subtitle = "Higher BMI categories show increased stroke cases",
    x = "BMI Category",
    y = "Number of Patients",
    fill = "Stroke Status"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
summary(stroke_df)
#Stroke by Average glucose levels
ggplot(stroke_df, aes(x = stroke, y = avg_glucose_clean, fill = stroke)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_manual(values = stroke_colors) +
  labs(
    title = "Average Glucose Level by Stroke Status",
    subtitle = "Stroke patients show higher glucose levels",
    x = "Stroke Status",
    y = "Average Glucose Level",
    fill = "Stroke"
  ) +
  theme_minimal()
#Convert stroke to numeric
stroke_df$stroke_num <- ifelse(stroke_df$stroke == "Yes", 1, 0)
summary(stroke_df)
#Building our glm mdel
stroke_model <- glm(
  stroke_num ~ age_clean + avg_glucose_clean + bmi_clean + gender +
    hypertension + heart_disease + smoking_status_clean,
  data = stroke_df,
  family = binomial
)
summary(stroke_model)
#Odds Ratio
exp(cbind(Odds_Ratio = coef(stroke_model), confint(stroke_model)))

##Lets carry out feature importance
ls()
model_coeffs <- summary(stroke_model)$coefficients
#ets convert to a data frame
feature_importance <- data.frame(
  Feature = rownames(model_coeffs),
  Estimate = model_coeffs[, "Estimate"],
  P_Value = model_coeffs[, "Pr(>|z|)"]
)
#Removing the intercepts
library(dplyr)

feature_importance <- feature_importance %>%
  filter(Feature != "(Intercept)")
#We sort them by importance
feature_importance <- feature_importance %>%
  arrange(desc(abs(Estimate)))
#plotting our feature importance
ggplot(feature_importance,
       aes(x = reorder(Feature, abs(Estimate)), y = Estimate, fill = Estimate > 0)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_fill_manual(
    values = c("TRUE" = "#D62728", "FALSE" = "#1F77B4"),
    labels = c("Increases Stroke Risk", "Decreases Stroke Risk")
  ) +
  labs(
    title = "Feature Importance for Stroke Prediction",
    subtitle = "Based on logistic regression coefficients",
    x = "Predictor Variables",
    y = "Log-Odds Impact",
    fill = "Effect Direction"
  ) +
  theme_minimal()

#Transffering data to power bi
write.csv(stroke_df, 
          "health_stroke_powerbi.csv", 
          row.names = FALSE)
#Getting the location where it has been saved
getwd()
#Lets also export the summary tables;
#By age
stroke_by_age <- stroke_df %>%
  group_by(age_clean, stroke) %>%
  summarise(count = n(), .groups = "drop")

write.csv(stroke_by_age, "stroke_by_age_powerbi.csv", row.names = FALSE)
#Stroke by bmi
stroke_by_bmi <- stroke_df %>%
  group_by(bmi_clean, stroke) %>%
  summarise(count = n(), .groups = "drop")

write.csv(stroke_by_bmi, "stroke_by_bmi_powerbi.csv", row.names = FALSE)
#Stroke by smoking status
stroke_by_smoking<-stroke_df %>%
  group_by(smoking_status_clean,stroke) %>%
  summarise(count =n(), .groups = "drop")
write.csv(stroke_by_smoking, "stroke_by_smoking_powerbi.csv", row.names = FALSE)
#stroke by gender
stroke_by_gender<-stroke_df %>%
  group_by(gender,stroke) %>%
  summarise(count =n(), .groups = "drop")
write.csv(stroke_by_gender, "stroke_by_gender_powerbi.csv", row.names = FALSE)
#Feature importance
write.csv(feature_importance, 
          "stroke_feature_importance.csv", 
          row.names = FALSE)
