# Health Insurance Charges Predictor 

My mission is centered on revolutionizing the healthcare system by integrating advanced technology and using machine learning and data science skills to provide data-driven insights for better decision-making. I aim to enhance accessibility and efficiency, improving the overall well-being of individuals and healthcare providers

### Overview:
This application uses machine learning techniques- specifically linear regression model to help predict the insurance charges of the policyholders by considering various factors.

### Dataset:
The data I have used for my application is sourced from Kaggle. 

### Dataset Description:
Age - This is the age of each insurance holder in years. It is a quantitative variable

Sex - The gender of the insurance holder (Can either be 'male' represented by 0 or 'female' represented by 1). This is a qualitative variable but encoded numerically.

BMI - This is the Body Mass Index which is a measure of body fat based on weight and height. This is a quantitative variable.

Children - This is the number of dependents covered by the insurance. It is a quantitative variable.

Smoker - This is the smoking status (Can either be 'yes' denoted by 1 or 'no' denoted by 0). It is a qualitative variable but encoded numerically.

Region - This is the region where the insurance holder resides in. (It can be 'northwest' denoted by 1, or 'northeast' denoted by 2, or 'southwest' denoted by 3, or 'southeast' denoted by 4). It is a categorical variable but encoded numerically.

Charges - This is the response variable and it is quantitative. It is the output we will receive after inserting the variables above as inputs to give us a prediction.


### Machine Learning Model:
I employed three different models to find the best fit for my prediction. These are the Random Forest Model, Linear Model (Gradient Descent), and Decision Tree model. 
The Random Forest model was the most accurate with having the most minimal MSE. Therefore I employed it throughout the rest of my application. 


### Technology Used:
Backend- Python with FastAPI for API development, Render to host my deployed API.
Frontend - Flutter.
Model - Scikit learn library from python.


## Running the Mobile App:
### Prerequisites:
Ensure you have the following installed on your machine:
 - Flutter SDK (2.x or later).
 - Android Studio or Visual Studio Code.
 - An Android or iOS emulator or a physical device.


### Step by Step instructions:
Clone the Repository:
    
    git clone https://github.com/m-mwangi/linear_regression_model.git

    
Navigate to the Project Directory:

    cd insurance_prediction_app
   
 
Install Dependencies:

    flutter pub get
    

Run the App:

   flutter run
   
 
This will launch the app on the emulator or device.




