Environment env;
Command cmd;

float phase = 1;
float vFinal = 0.5;
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

    // First phase: ...
    if (phase == 1) {
        cmd.setThrustCommand(0.5 - (env.getStarshipVy() - (-1.0)));
        cmd.setThrustAngleCommand(
            0.1 * (env.getStarshipAngle() - max(-PI/180, min(PI/180,
                1.0 * (3.0 - env.getStarshipVx()) * PI/180))) +
            0.1 * env.getStarshipOmega());
    }

    // Second phase: ...
    if (abs(env.getStarshipXPosition() - env.getDestinationX()) < 200 &&
            phase == 1) {
        phase = 2;
    }
    if (phase == 2) {
        vFinal = 0.5 + min(0, (env.getStarshipXPosition() - 10.0) * 0.05);
        thrustAngleDes = max(-PI/180, min(PI/180, 1.0 * (vFinal -
            env.getStarshipVx()) * PI/180));
            
        cmd.setThrustAngleCommand(
            0.1 * (env.getStarshipAngle() - thrustAngleDes) +
            0.1 * env.getStarshipOmega());
        cmd.setThrustCommand(max(0.5, min(0.55,
            0.5 - env.getStarshipYPosition()) - env.getStarshipVy()));
    }

    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------

    // Update
    env.updateStarship(cmd);
}
