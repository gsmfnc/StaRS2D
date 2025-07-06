Environment env;
Command cmd;

float phase = 1;
float velDes = -1.0;
float thrustAngleDes = 0.0;

void setup() {
    size(1200, 600);
    
    env = new Environment();
    cmd = new Command();
}

void draw() {
    env.initialize();

    // -------------------------------------------------------------------------
    // ------------------------- Controller design -----------------------------
    // -------------------------------------------------------------------------
    if (phase == 1) {
        cmd.setThrustCommand(0.5 - (env.getStarshipVy() - velDes));

        thrustAngleDes = max(-PI/180, min(PI/180,
            1.0 * (3.0 - env.getStarshipVx()) * PI/180));
        cmd.setThrustAngleCommand(
            1.0 * (env.getStarshipAngle() - thrustAngleDes) +
            1.3 * env.getStarshipOmega());
    }

    if (abs(env.getStarshipXPosition() - env.getDestinationX()) < 200 &&
            phase == 1) {
        phase = 2;
    }
    if (phase == 2) {
        velDes = 0.5 + min(0, (env.getStarshipXPosition() - 10.0) * 0.05);
        thrustAngleDes = max(-PI/180, min(PI/180, 1.0 * (velDes -
            env.getStarshipVx()) * PI/180));

        cmd.setThrustAngleCommand(
            1.0 * (env.getStarshipAngle() - thrustAngleDes) +
            1.3 * env.getStarshipOmega());
        cmd.setThrustCommand(max(0.5, min(0.55,
            0.5 - env.getStarshipYPosition()) - env.getStarshipVy()));
    }
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------

    // Update
    env.updateStarship(cmd);
}
