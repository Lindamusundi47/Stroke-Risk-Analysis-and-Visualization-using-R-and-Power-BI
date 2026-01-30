
# Stroke Risk Analysis and Visualization Using R and Power BI

##  Project Overview
Stroke is a major public health concern and one of the leading causes of death and long-term disability worldwide.  
This project performs an end-to-end data analysis to identify key risk factors associated with stroke using statistical modeling and data visualization.

The workflow covers:
- Data cleaning and preparation in Excel
- Exploratory data analysis and modeling in R
- Interactive dashboard development in Power BI

## Objectives
- Clean and standardize stroke health data
- Explore demographic and clinical risk factors
- Build a logistic regression model to predict stroke risk
- Identify important predictors of stroke
- Create interactive visualizations using Power BI


## Dataset Description
The data was obtained from Kaggle: <a href="https://github.com/Lindamusundi47/Stroke-Risk-Analysis-and-Visualization-using-R-and-Power-BI/blob/main/healthcare-dataset-stroke-data.csv">Dataset</a>

The dataset contains patient-level health information, including:

- id – Unique patient identifier  
- gender – Male, Female, Other  
- age – Age of the patient  
- hypertension– 0 = No, 1 = Yes  
- heart_disease – 0 = No, 1 = Yes  
- ever_married – Yes / No  
- work_type – Employment category  
- Residence_type – Urban / Rural  
- avg_glucose_level– Average blood glucose level  
- bmi– Body Mass Index  
- smoking_status – Smoking behavior  
- stroke – Target variable (0 = No Stroke, 1 = Stroke)

## Data Cleaning
Data cleaning was performed primarily in Excel and included:
- Handling missing BMI values
- Standardizing categorical variables
- Converting binary variables to meaningful labels
- Creating age and BMI categories
- Ensuring consistent formatting for analysis and visualization
- The cleaned data:<a href="https://github.com/Lindamusundi47/Stroke-Risk-Analysis-and-Visualization-using-R-and-Power-BI/blob/main/Clean_stroke_data.xlsb">Cleaned Dataset</a>

The cleaned dataset was exported for analysis in R and visualization in Power BI.


## Exploratory Data Analysis (EDA)
EDA was conducted in R to examine:
- Age and BMI distributions
- Stroke prevalence across demographic groups
- Relationships between stroke and clinical risk factors

Visualizations include histograms, bar charts, and proportion plots.


## Statistical Modeling
A logistic regression model was fitted to predict the probability of stroke.

### Model Features:
- Age
- Average glucose level
- BMI category
- Gender
- Hypertension
- Heart disease
- Smoking status

### Findings:
- Age and average glucose level significantly increase stroke risk
- Hypertension and severe obesity are strong predictors
- Some lifestyle and demographic factors showed weaker associations


## Feature Importance
Model coefficients were extracted and visualized to show:
- Direction of effect (increases or decreases stroke risk)
- Relative importance of predictors

These results were used to guide Power BI visual storytelling.


##  Power BI Dashboard
I created an interactive Power BI dashboard to:<a href="https://github.com/Lindamusundi47/Stroke-Risk-Analysis-and-Visualization-using-R-and-Power-BI/blob/main/Stroke-Analysis%20Dashboard.png"> Dashboard</a>
- Display key KPIs
- Explore stroke trends by age, gender, BMI, and health conditions
- Enable filtering through slicers for deeper analysis


## Tools & Technologies Used
- Excel– Data cleaning and preparation  
- R – Data analysis, visualization, and logistic regression  
- Power BI – Interactive dashboards and reporting  


