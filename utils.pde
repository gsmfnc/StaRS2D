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

    void addX(float xPlus) {
        this.x = this.x + xPlus;
    }
    void addY(float yPlus) {
        this.y = this.y + yPlus;
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

    void addTheta(float thetaPlus) {
        this.theta = this.theta + thetaPlus;
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

    float maxThrust = 2.0;
    float maxThrustAngle = PI/6;

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
