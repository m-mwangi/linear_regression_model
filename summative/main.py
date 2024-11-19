# Import necessary libraries
from fastapi import FastAPI
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import joblib
import pandas as pd

# Load your model (make sure to specify the correct path)
model_path = "C:\\Users\\mario\\Downloads\\best_random_forest_model.pkl"  # Update with your model path
rf_model = joblib.load(model_path)

# Define input data structure using Pydantic
class PredictionInput(BaseModel):
    age: int = Field(..., ge=0, le=120)  # Age must be between 0 and 120
    sex: int = Field(..., ge=0, le=1)     # Sex (0 or 1)
    bmi: float = Field(..., ge=10.0, le=50.0)  # BMI must be between 10 and 50
    children: int = Field(..., ge=0)      # Number of children must be non-negative
    smoker: int = Field(..., ge=0, le=1)   # Smoker status (0 or 1)
    region_northwest: int = Field(..., ge=0, le=1)
    region_southeast: int = Field(..., ge=0, le=1)
    region_southwest: int = Field(..., ge=0, le=1)

# Initialize FastAPI app
app = FastAPI()

# Allow CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this to your needs
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health check endpoint
@app.get('/health')
def health_check():
    return {"message": "Server is running and everything is okay!"}

@app.post('/predict')
def predict(input_data: PredictionInput):
    # Convert input data to DataFrame
    input_df = pd.DataFrame([input_data.dict()])

    # Make a prediction using the loaded model
    predicted_value = rf_model.predict(input_df)

    # Return the predicted value
    return {"predicted_insurance_charges": predicted_value[0]}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)