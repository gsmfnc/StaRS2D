class Starship {
    Position p;
    Angle a;

    Actuators act;

    int hasCollided = 0;
    int missionSuccess = 0;

    float lx = 10;
    float ly = 50;
    float greyVal = 119;
    float gravityVel = 1.0;
    float inertia = 0.01;
    // float gravityVel = 9.81;
    // float inertia = 0.1;
    float Ts = 0.1;

    float vx;
    float vy;
    float omega;

    Starship(Position p, Angle a, Actuators act) {
        this.p = p;
        this.a = a;
        this.act = act;

        this.vx = 0;
        this.vy = 0;
        this.omega = 0;
    }

    void computeNewPosition() {
        /*
        this.vx = this.vx + 
            sin(this.getAngle().getTheta()) * this.act.getThrust() * this.Ts;
        this.vy = this.vy + (this.gravityVel - cos(this.getAngle().getTheta()) *
            this.act.getThrust())  * this.Ts;
        this.p.addX(this.vx * this.Ts * this.Ts / 2);
        this.p.addY(this.vy * this.Ts * this.Ts / 2);
        */
        if (hasCollided == 0 && missionSuccess == 0) {
            this.vx = sin(this.getAngle().getTheta()) * this.act.getThrust();
            this.vy = this.gravityVel - cos(this.getAngle().getTheta()) *
                this.act.getThrust();

            this.p.addX(this.vx);
            this.p.addY(this.vy);
        }
    }

    void computeNewAngle() {
        /*
        this.omega = this.omega + sin(this.act.getThrustAngle()) *
            this.act.getThrust() * this.ly / 2 * this.inertia * this.Ts;
        this.a.addTheta(this.omega * this.Ts * this.Ts / 2);
        */
        if (hasCollided == 0 && missionSuccess == 0) {
            this.omega = sin(this.act.getThrustAngle()) *
                this.act.getThrust() * this.ly / 2 * this.inertia;
            this.a.addTheta(this.omega);
        }
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
    float getVx() {
        return this.vx;
    }
    float getVy() {
        return this.vy;
    }
    float getOmega() {
        return this.omega;
    }

    // Setters
    void setActuators(Actuators act) {
        this.act = act;
    }
}
