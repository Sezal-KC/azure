from flask import Flask, render_template, request, redirect
import mysql.connector

app = Flask(__name__)

# DB connection
conn = mysql.connector.connect(
    host="db",
    user="root",
    password="password",
    database="todo_app"
)
cursor = conn.cursor(dictionary=True)

@app.route('/')
def index():
    cursor.execute("SELECT * FROM tasks")
    tasks = cursor.fetchall()
    return render_template('index.html', tasks=tasks)

@app.route('/add', methods=['POST'])
def add():
    task_content = request.form['content']
    cursor.execute("INSERT INTO tasks (content) VALUES (%s)", (task_content,))
    conn.commit()
    return redirect('/')

@app.route('/delete/<int:task_id>')
def delete(task_id):
    cursor.execute("DELETE FROM tasks WHERE id = %s", (task_id,))
    conn.commit()
    return redirect('/')

@app.route('/toggle/<int:task_id>')
def toggle(task_id):
    cursor.execute("UPDATE tasks SET completed = NOT completed WHERE id = %s", (task_id,))
    conn.commit()
    return redirect('/')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

