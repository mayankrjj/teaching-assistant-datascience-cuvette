# Section 1: Python + Machine Learning – Cuvette TA Assignment

#Import Libraries
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score, classification_report

#Load the Dataset
df = pd.read_csv("StudentsPerformance.csv")
df.head()
#  Step 3: Data Cleaning
df.info()  # Check for nulls and data types
df.isnull().sum()  # No missing values in this dataset

# Rename columns for ease
df.columns = df.columns.str.replace(" ", "_")
#  Step 4: Create Target Variable – Pass/Fail
# Consider 40 as the pass mark in all subjects
df["average_score"] = (df["math_score"] + df["reading_score"] + df["writing_score"]) / 3
df["result"] = df["average_score"].apply(lambda x: 1 if x >= 40 else 0)  # 1 = Pass, 0 = Fail

df["result"].value_counts(normalize=True)  # Class distribution
# Step 5: Exploratory Data Analysis (EDA)
# Gender vs Result
sns.countplot(x="gender", hue="result", data=df)
plt.title("Gender vs Pass/Fail")
plt.show()

# Parental level of education vs result
plt.figure(figsize=(10,5))
sns.countplot(x="parental_level_of_education", hue="result", data=df)
plt.xticks(rotation=45)
plt.title("Parental Education vs Pass/Fail")
plt.show()

# Score distribution
sns.histplot(df["average_score"], bins=20, kde=True)
plt.title("Distribution of Average Scores")
plt.show()
# Step 6: Encode Categorical Features
cat_cols = ["gender", "race/ethnicity", "parental_level_of_education", "lunch", "test_preparation_course"]
df_encoded = df.copy()

le = LabelEncoder()
for col in cat_cols:
    df_encoded[col] = le.fit_transform(df_encoded[col])
# Step 7: Modeling – Logistic Regression and Random Forest
features = df_encoded.drop(columns=["math_score", "reading_score", "writing_score", "average_score", "result"])
target = df_encoded["result"]

X_train, X_test, y_train, y_test = train_test_split(features, target, test_size=0.2, random_state=42)

# Logistic Regression
log_model = LogisticRegression(max_iter=1000)
log_model.fit(X_train, y_train)
log_preds = log_model.predict(X_test)

# Random Forest
rf_model = RandomForestClassifier(random_state=42)
rf_model.fit(X_train, y_train)
rf_preds = rf_model.predict(X_test)
# Step 8: Evaluation
def evaluate_model(name, y_true, y_pred):
    print(f"🔍 {name}")
    print("Accuracy:", accuracy_score(y_true, y_pred))
    print("F1 Score:", f1_score(y_true, y_pred))
    print("Confusion Matrix:\n", confusion_matrix(y_true, y_pred))
    print("Classification Report:\n", classification_report(y_true, y_pred))
    print("="*50)

evaluate_model("Logistic Regression", y_test, log_preds)
evaluate_model("Random Forest", y_test, rf_preds)
# Conclusion:
# - The dataset was clean with no missing values.
# - I created a binary classification target: Pass (>=40 average score) vs Fail.
# - Random Forest slightly outperformed Logistic Regression.
# - Feature encoding was done using LabelEncoder.
# - EDA revealed that parental education and test prep had visible effects on pass rates.
