class Starship {
    Position p;
    Angle a;

    Actuators act;

    float lx = 10;
    float ly = 50;
    float greyVal = 119;
    float gravityVel = 1.0;
    float inertia = 0.01;

    Starship(Position p, Angle a, Actuators act) {
        this.p = p;
        this.a = a;
        this.act = act;
    }

    void computeNewPosition() {
        this.p.addX(sin(this.getAngle().getTheta()) * this.act.getThrust());
        this.p.addY(this.gravityVel - cos(this.getAngle().getTheta()) *
            this.act.getThrust());
    }

    void computeNewAngle() {
        this.a.addTheta(sin(this.act.getThrustAngle()) *
            this.act.getThrust() * this.ly / 2 * this.inertia);
    }

    // Getters
    Position getPosition() {
        return this.p;
    }
    Angle getAngle() {
        return this.a;
    }
    float getGreyVal() {
        return this.greyVal;
    }
    float getLx() {
        return this.lx;
    }
    float getLy() {
        return this.ly;
    }
    Actuators getActuators() {
        return this.act;
    }

    // Setters
    void setActuators(Actuators act) {
        this.act = act;
    }
}
