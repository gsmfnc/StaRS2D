class Environment {
    Position p_des;
    Starship starship;

    Environment() {
        Position p = new Position(1100.0, 50.0);
        Angle a = new Angle(0);
        Actuators act = new Actuators(0.0, 0.0);
        starship = new Starship(p, a, act);

        p_des = new Position(30.0, 435.0);
    }
    
    void initialize() {
        noStroke();
        this.drawBack();
        this.drawClouds();
        this.drawGround();
        this.drawDestination();
        this.drawStarship();
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
        rect(0, 0, 1200, 100);

        popMatrix();
    }

    void drawDestination() {
        pushMatrix();

        translate(this.p_des.getX(), this.p_des.getY());
        fill(#000000);
        rect(-10, -70 + 65, 10, 70);
        fill(#FF0000);
        rect(0, 0, 10, 10);

        popMatrix();
    }

    void drawStarship() {
        pushMatrix();

        this.starship.computeNewPosition();
        this.starship.computeNewAngle();

        this.starship.getPosition().translatePosition();
        this.starship.getAngle().rotateAngle();

        fill(this.starship.getGreyVal(), this.starship.getGreyVal(),
            this.starship.getGreyVal());
        translate(- this.starship.getLx() / 2, - this.starship.getLy() / 2);
        rect(0, 0, this.starship.getLx(), this.starship.getLy());

        popMatrix();
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
    float getStarshipYPosition() {
        return - this.starship.getPosition().getY() + this.p_des.getY();
    }
    float getStarshipAngle() {
        return -this.starship.getAngle().getTheta();
    }
    float getDestinationX() {
        return 0.0;
    }
    float getDestinationY() {
        return 0.0;
    }
}
