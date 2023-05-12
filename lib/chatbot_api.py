from flask import Flask, request
from collections import namedtuple
import AmexChatbot
import pandas as pd
import numpy as np

app = Flask(__name__)


@app.route('/')
def index():
    return '<h1>Home Page</h1>'


@app.route('/api')
def api():
    user_input = request.args.get('input')
    response = generate_response(user_input)

    json = {
        'input': user_input,
        'response': response,
    }

    return json



def generate_response(inp: str) -> str:
    
    if inp.lower()=="quit" or inp.lower()=="bye":
      return ""

    results=AmexChatbot.model.predict([AmexChatbot.bag_of_words(inp,AmexChatbot.words)])
    results_index=np.argmax(results)
    tag=AmexChatbot.labels[results_index]

    for tg in AmexChatbot.data["intents"]:
      if tg["tag"]==tag:
        response=tg['responses']

    corpus_text = AmexChatbot.listToString(response)
    return AmexChatbot.answer(corpus_text,inp)


if __name__ == '__main__':
    app.run()