from fastapi import FastAPI
from pydantic import BaseModel
from sentence_transformers import SentenceTransformer, util

# initialize FastAPI
app = FastAPI(title="Answer Similarity API", version="1.0")

# Load model
model = SentenceTransformer('sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2')
# model = SentenceTransformer('distiluse-base-multilingual-cased-v2')

# Question Requst
class AnswerCheckRequest(BaseModel):
    user_answer: str
    correct_answer: str

# Route to check the answer
@app.post("/check")
def check_answer(data: AnswerCheckRequest):
    user_embedding = model.encode(data.user_answer, convert_to_tensor=True)
    correct_embedding = model.encode(data.correct_answer, convert_to_tensor=True)
    similarity = util.pytorch_cos_sim(user_embedding, correct_embedding).item()
    
    return {"similarity": round(similarity, 4)}