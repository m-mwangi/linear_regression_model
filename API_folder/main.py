from fastapi import FastAPI
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import joblib
import pandas as pd
import os

# Set up relative paths for the model and scaler
BASE_DIR = os.path.dirname(os.path.abspath(__file__))  # Directory of the current script
rf_model_path = os.path.join(BASE_DIR, "best_random_forest_model.pkl")
scaler_path = os.path.join(BASE_DIR, "charges_scaler.pkl")

# Load the trained Random Forest model and the scaler used for 'charges'
rf_model = joblib.load(rf_model_path)
scaler = joblib.load(scaler_path)

# Define a function to preprocess the input data
def preprocess_input(input_data: pd.DataFrame) -> pd.DataFrame:
    # Map categorical features to numeric values
    num_data = {
        'sex': {'male': 0, 'female': 1},
        'smoker': {'yes': 1, 'no': 0},
        'region': {'northwest': 1, 'northeast': 2, 'southeast': 3, 'southwest': 4}
    }
    
    # Replace categorical features with numeric values
    input_data = input_data.replace(num_data)
    
    # Drop 'charges' column because it's not part of input features
    input_data = input_data.drop('charges', axis=1, errors='ignore')
    
    return input_data

# Define input data structure using Pydantic
class PredictionInput(BaseModel):
    age: int = Field(..., ge=0, le=120)  # Age must be between 0 and 120
    sex: str = Field(..., pattern="^(male|female)$")  # Sex: 'male' or 'female'
    bmi: float = Field(..., ge=10.0, le=50.0)  # BMI must be between 10 and 50
    children: int = Field(..., ge=0)  # Number of children must be non-negative
    smoker: str = Field(..., pattern="^(yes|no)$")  # Smoker status: 'yes' or 'no'
    region: str = Field(..., pattern="^(northwest|northeast|southeast|southwest)$")  # Region: one of the four regions


# Initialize FastAPI app
app = FastAPI()

# Allow CORS (Cross-Origin Resource Sharing)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this to your needs
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Welcome to the Health Insurance Predictor Charges API!"}

# Health check endpoint
@app.get("/health")
def health_check():
    return {"message": "Server is running and everything is okay!"}

# Prediction endpoint
@app.post("/predict")
def predict(input_data: PredictionInput):
    # Convert input data to DataFrame
    input_df = pd.DataFrame([input_data.dict()])
    
    # Preprocess input data
    processed_input = preprocess_input(input_df)
    
    # Make a prediction using the Random Forest model
    predicted_charge = rf_model.predict(processed_input)
    
    # Inverse standardize the 'charges' prediction to get the original scale
    try:
        predicted_charge_original = scaler.inverse_transform(predicted_charge.reshape(-1, 1))
        return {"predicted_insurance_charges": predicted_charge_original[0][0]}
    except Exception as e:
        return {"error": f"Error during inverse transformation: {e}"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

