class Position {
    float x;
    float y;

    Position(float x, float y) {
        this.x = x;
        this.y = y;
    }

    void translatePosition() {
        translate(this.x, this.y);
    };

    void addX(float x_plus) {
        this.x = this.x + x_plus;
    }
    void addY(float y_plus) {
        this.y = this.y + y_plus;
    }

    // Getters
    float getX() {
        return this.x;
    }
    float getY() {
        return this.y;
    }
}

class Angle {
    float theta;

    Angle(float theta) {
        this.theta = theta;
    }

    void addTheta(float theta_plus) {
        this.theta = this.theta + theta_plus;
    }

    void rotateAngle() {
        rotate(this.theta);
    }

    // Getters
    float getTheta() {
        return this.theta;
    }
}

class Actuators {
    float thrust;
    float thrustAngle;

    float maxThrust = 2;
    float maxThrustAngle = PI/2;

    Actuators(float thrust, float thrustAngle) {
        this.thrust = thrust;
        this.thrustAngle = thrustAngle;
    }

    // Getters and setters
    void setThrust(float thrust) {
        if (thrust < 0)
            thrust = 0;
        else if (thrust > 1)
            thrust = 1;

        this.thrust = thrust * maxThrust;
    }
    void setThrustAngle(float thrustAngle) {
        this.thrustAngle = thrustAngle;
        if (this.thrustAngle > this.maxThrustAngle)
            this.thrustAngle = this.maxThrustAngle;
        else if (this.thrustAngle < -this.maxThrustAngle)
            this.thrustAngle = -this.maxThrustAngle;
    }
    float getThrust() {
        return this.thrust;
    }
    float getThrustAngle() {
        return this.thrustAngle;
    }
}

class Command {
    float thrustCommand;
    float thrustAngleCommand;

    Command() {
        this.thrustCommand = 0.0;
        this.thrustAngleCommand = 0.0;
    }

    // Getters and setters
    void setThrustCommand(float thrustCommand) {
        this.thrustCommand = thrustCommand;
    }
    void setThrustAngleCommand(float thrustAngleCommand) {
        this.thrustAngleCommand = -thrustAngleCommand;
    }
    float getThrustCommand() {
        return this.thrustCommand;
    }
    float getThrustAngleCommand() {
        return this.thrustAngleCommand;
    }
}
