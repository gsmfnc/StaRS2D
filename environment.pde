class Environment {
    Position p_des;
    Starship starship;
    Position[] starshipBorderPoints;

    // ground parameters
    float groundHeight = 100;

    // destination tower parameters
    float towerWidth = 10;
    float towerHeight = 90;
    float towerSupportWidth = 20;
    float towerSupportHeight = 10;

    float timeToComplete;

    int level = 1;
    int simplified = 0;

    Environment() {
        Position p = new Position(1100.0, 50.0);
        Angle a = new Angle(0);
        Actuators act;
        if (this.simplified == 1)
            act = new Actuators(0.0, 0.0);
        else
            act = new Actuators(0.0, 0.0, 9.81);

        starship = new Starship(p, a, act);

        p_des = new Position(35.0, 440.0);

        starshipBorderPoints = new Position[8];
        computeBorderPoints();

        timeToComplete = 0;
    }
    
    void initialize() {
        noStroke();
        this.drawBack();
        this.drawClouds();
        this.drawGround();
        this.checkMissionSuccess();
        this.checkCollisions();
        this.drawStarship();
        this.drawDestination();
        this.drawInstrumentation();

        // draw border points for debugging reasons
        // pushMatrix();
        // translate(this.p_des.getX(), this.p_des.getY());
        // fill(#FF0000);
        // for (int i = 0; i < 8; i++) {
        //     circle(this.starshipBorderPoints[i].getX(),
        //         -this.starshipBorderPoints[i].getY(),
        //         5);
        // }
        // popMatrix();
    }
    
    void drawBack() {
        background(135, 206, 235);
    }

    void drawClouds() {
        pushMatrix();
        fill(#FFFFFF);

        translate(100, 100);
        this.drawCloud();

        translate(300, 100);
        this.drawCloud();

        translate(50, -200);
        this.drawCloud();

        translate(500, 150);
        this.drawCloud();

        popMatrix();
    }

    void drawCloud() {
        circle(60, 100, 60);
        circle(100, 100, 80);
        circle(140, 100, 60);
    }

    void drawGround() {
        pushMatrix();

        translate(0, 500);
        fill(#00FF00);
        rect(0, 0, 1200, this.groundHeight);

        popMatrix();
    }

    void drawDestination() {
        pushMatrix();

        translate(this.p_des.getX(), this.p_des.getY());
        fill(#000000);
        rect(-this.towerWidth * 2, -this.towerHeight * 0.3,
            this.towerWidth, this.towerHeight);
        rect(-this.towerWidth, -this.towerHeight * 0.166,
            this.towerSupportWidth, this.towerSupportHeight);
        fill(#FF0000);
        circle(0, 0, 10);

        popMatrix();
    }

    void drawStarship() {
        pushMatrix();

        this.starship.computeNewPosition(this.simplified);
        this.starship.computeNewAngle(this.simplified);

        this.starship.getPosition().translatePosition();
        this.starship.getAngle().rotateAngle();

        translate(- this.starship.getLx() / 2, - this.starship.getLy() / 2);

        pushMatrix();
        // thrust animation
        translate(this.starship.getLx() / 2, this.starship.getLy());
        fill(#FF0000);

        rotate(this.starship.getActuators().getThrustAngle());
        triangle(this.starship.getLx() / 3, 0,
            - this.starship.getLx() / 3, 0,
            0, this.starship.getActuators().getThrust() /
                this.starship.getActuators().maxThrust * 40);

        fill(#FFA500);
        triangle(this.starship.getLx() / 3, 0,
            -this.starship.getLx() / 3, 0,
            0, this.starship.getActuators().getThrust() /
                this.starship.getActuators().maxThrust * 20);
        popMatrix();
                
        // starship
        fill(this.starship.getGreyVal(), this.starship.getGreyVal(),
            this.starship.getGreyVal());
        rect(0, 0, this.starship.getLx(), this.starship.getLy());

        popMatrix();
    }

    void drawInstrumentation() {
        pushMatrix();
        translate(500, 520);

        fill(#000000);
        textSize(20);
        text("x [pix]: ", 0, 0); 
        text(String.valueOf(nf(this.getStarshipXPosition(), 0, 2)), 80, 0);
        text("y [pix]: ", 0, 20); 
        text(String.valueOf(nf(this.getStarshipYPosition(), 0, 2)), 80, 20);
        text("θ [deg]: ", 0, 40); 
        text(String.valueOf(nf(this.getStarshipAngle() * 180 / PI, 0, 7)),
            80, 40);

        text("Vx [pix/sec]: ", 200, 0);
        text(String.valueOf(nf(-this.starship.getVx(), 0, 2)),
            310, 0);
        text("Vy [pix/sec]: ", 200, 20);
        text(String.valueOf(nf(-this.starship.getVy(), 0, 2)),
            310, 20);
        text("ω [deg/sec]: ", 200, 40);
        text(String.valueOf(nf(-this.starship.getOmega() * 180 / PI,
            0, 7)), 310, 40);

        text("Thrust [%]:", 400, 0);
        text(String.valueOf(nf(this.starship.getActuators().getThrust() /
            this.starship.getActuators().maxThrust, 0, 7)), 575, 0);
        text("Thrust angle [deg]:", 400, 20);
        text(String.valueOf(nf(-this.starship.getActuators().getThrustAngle() *
            180 / PI, 0, 7)), 575, 20);
        text("Seconds elapsed:", 400, 40);
        if (this.starship.missionSuccess == 0)
            text(String.valueOf(this.getElapsedTime()), 575, 40);
        else
            text(String.valueOf(this.timeToComplete), 575, 40);

        popMatrix();
    }

    void checkMissionSuccess() {
        if (this.starship.hasCollided == 1)
            return;
        if (abs(this.getStarshipXPosition()) <= 1 &&
                abs(this.getStarshipYPosition()) <= 1 &&
                abs(this.getStarshipAngle() * 180/PI) <= 0.5) {
            if (abs(this.starship.getVy()) < 0.1 &&
                    abs(this.starship.getVx()) < 0.1) {
                if (this.starship.missionSuccess == 0)
                    this.timeToComplete = this.getElapsedTime();
                this.starship.missionSuccess = 1;
                textSize(60);
                fill(#00FF00);
                text("Success!", 500, 200);
                textSize(30);
                text("Time [sec]: ", 490, 250);
                text(String.valueOf(this.timeToComplete), 650, 250);
            } else {
                this.starship.hasCollided = 1;
                this.starship.highSpeedFail = 1;
            }
        }
    }

    void checkCollisions() {
        this.computeBorderPoints();
        if (this.starship.missionSuccess == 1)
            return;
        for (int i = 0; i < 8; i++) {
            if (this.starshipBorderPoints[i].getY() + 70 < 0) {
                this.starship.hasCollided = 1;

                textSize(40);
                fill(#FF0000);
                text("Collision with the ground!", 400, 100);
            }

            if (this.starshipBorderPoints[i].getX() < -this.towerWidth &&
                  this.starshipBorderPoints[i].getX() > -this.towerWidth*2 &&
                  this.starshipBorderPoints[i].getY() < this.towerHeight*0.3 &&
                  this.starshipBorderPoints[i].getY() > -this.towerHeight*0.7) {
                this.starship.hasCollided = 1;

                textSize(40);
                fill(#FF0000);
                text("Collision with the tower!", 400, 100);
            }
        }
        if (this.starship.highSpeedFail == 1) {
            textSize(40);
            fill(#0000FF);
            text("So close...", 500, 200);
            text("Starship's velocity was too high while landing!",
                200, 250);
        }
    }

    void updateStarship(Command cmd) {
        Actuators tmp = this.starship.getActuators();
        tmp.setThrust(cmd.getThrustCommand());
        tmp.setThrustAngle(cmd.getThrustAngleCommand());
        this.starship.setActuators(tmp);
    }

    // Getters
    float getStarshipXPosition() {
        return this.starship.getPosition().getX() - this.p_des.getX();
    }
    float getStarshipVx() {
        return -this.starship.getVx();
    }
    float getStarshipYPosition() {
        return - this.starship.getPosition().getY() + this.p_des.getY();
    }
    float getStarshipVy() {
        return -this.starship.getVy();
    }
    float getStarshipAngle() {
        return -this.starship.getAngle().getTheta();
    }
    float getStarshipOmega() {
        return -this.starship.getOmega();
    }
    float getDestinationX() {
        return 0.0;
    }
    float getDestinationY() {
        return 0.0;
    }
    float getElapsedTime() {
        return float(millis() / 100) / 10;
    }

    // Setters
    void setLevel(int lvl) {
        this.level = lvl;
    }

    void computeBorderPoints() {
        this.starshipBorderPoints[0] = new Position(
            this.getStarshipXPosition() +
                cos(this.getStarshipAngle()) * this.starship.lx/2,
            this.getStarshipYPosition() +
                sin(this.getStarshipAngle()) * this.starship.lx/2);
        this.starshipBorderPoints[1] = new Position(
            this.getStarshipXPosition() -
                cos(this.getStarshipAngle()) * this.starship.lx/2,
            this.getStarshipYPosition() -
                sin(this.getStarshipAngle()) * this.starship.lx/2);
        this.starshipBorderPoints[2] = new Position(
            this.getStarshipXPosition() -
                sin(this.getStarshipAngle()) * this.starship.ly/2,
            this.getStarshipYPosition() +
                cos(this.getStarshipAngle()) * this.starship.ly/2);
        this.starshipBorderPoints[3] = new Position(
            this.getStarshipXPosition() +
                sin(this.getStarshipAngle()) * this.starship.ly/2,
            this.getStarshipYPosition() -
                cos(this.getStarshipAngle()) * this.starship.ly/2);
        this.starshipBorderPoints[4] = new Position(
            this.getStarshipXPosition() +
                cos(this.getStarshipAngle()) * this.starship.lx/2 -
                sin(this.getStarshipAngle()) * this.starship.ly/2,
            this.getStarshipYPosition() +
                sin(this.getStarshipAngle()) * this.starship.lx/2 +
                cos(this.getStarshipAngle()) * this.starship.ly/2);
        this.starshipBorderPoints[5] = new Position(
            this.getStarshipXPosition() +
                cos(this.getStarshipAngle()) * this.starship.lx/2 +
                sin(this.getStarshipAngle()) * this.starship.ly/2,
            this.getStarshipYPosition() +
                sin(this.getStarshipAngle()) * this.starship.lx/2 -
                cos(this.getStarshipAngle()) * this.starship.ly/2);
        this.starshipBorderPoints[6] = new Position(
            this.getStarshipXPosition() -
                cos(this.getStarshipAngle()) * this.starship.lx/2 -
                sin(this.getStarshipAngle()) * this.starship.ly/2,
            this.getStarshipYPosition() -
                sin(this.getStarshipAngle()) * this.starship.lx/2 +
                cos(this.getStarshipAngle()) * this.starship.ly/2);
        this.starshipBorderPoints[7] = new Position(
            this.getStarshipXPosition() -
                cos(this.getStarshipAngle()) * this.starship.lx/2 +
                sin(this.getStarshipAngle()) * this.starship.ly/2,
            this.getStarshipYPosition() -
                sin(this.getStarshipAngle()) * this.starship.lx/2 -
                cos(this.getStarshipAngle()) * this.starship.ly/2);
    }
}
