from flask import Flask
from flask import render_template
from flask import request
from flask import redirect
import pymysql
pymysql.install_as_MySQLdb()
from flask_mysqldb import MySQL
import MySQLdb.cursors


app = Flask(__name__)

app.config["MYSQL_USER"] = "flask_user"
app.config["MYSQL_PASSWORD"] = "secure_password_123"
app.config["MYSQL_DB"] = "videogames"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"
 
mysql = MySQL(app)

app.config["MYSQL_USER"]="flask_user"

@app.route("/")
def index():
    return render_template("index.html")
        
@app.route("/platform/delete/<int:platformID>")
def delete_platform(platformID):
     cur=mysql.connection.cursor()
     del_query = "DELETE FROM platform WHERE platformID = %s"
     try:
          cur.execute(del_query, (platformID))
          mysql.connection.commit()
          return redirect("/platforms")
     except:
          return "<h2> There was an issue deleting the"
     
@app.route("/platform/<int:platformID>", methods=["POST", "GET"])
def update_platform(platformID):
    cur = mysql.connection.cursor()
    if request.method=="POST":
        platform_name = request.form["platformName"]
        update_query = "UPDATE platform SET platformName= %s WHERE platformID=%s"
        try:
            cur.execute(update_query, (platform_name, platformID))
            mysql.connection.commit()
            return redirect("/platforms")
        except:
            return "<h2> There was an issue updating the platform.</h2>"
    else:
        cur.execute("SELECT * FROM platform WHERE platformID= %s", (platformID))
        platform_to_update = cur.fetchone()
        return render_template("platform.html", platform=platform_to_update, form_action=f"/platform/{platformID}")

@app.route("/platform", methods=["GET", "POST"])
def add_platform():
    cur=mysql.connection.cursor()
    if request.method=="POST":
        platform_name = request.form["platformName"]
        # insert from data
        add_query ="INSERT INTO platform VALUES(NULL, %s)"
        cur.execute(add_query, platform_name)
        mysql.connection.commit()
        # redirect to platforms page
        return redirect("/platforms")
    else:
        return render_template("platform.html", platform="", action="platform")

@app.route("/platforms")
def platforms():
    cur=mysql.connection.cursor()
    cur.execute("SELECT * FROM platform")
    resultset=cur.fetchall()
    return render_template("platforms.html", platforms=resultset)

@app.route("/consoles")
def consoles():
    return render_template("consoles.html")

@app.route("/games")
def games():
    cur=mysql.connection.cursor()
    cur.execute("SELECT g.gameID, g.gameName, g.releaseYear, g.playerRating, GROUP_CONCAT(c.consoleName ORDER BY c.consoleID SEPARATOR ', ') AS consoleNames FROM game g JOIN console_game cg ON g.gameID = cg.gameID JOIN console c ON cg.consoleID = c.consoleID GROUP BY g.gameID, g.gameName, g.releaseYear, g.playerRating")
    resultset=cur.fetchall()
    return render_template("games.html", games=resultset)

if __name__ == "__main__":
        app.run(debug=True)