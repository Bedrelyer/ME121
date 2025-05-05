function rigid_body_reorientation()
    % Define original and final vectors
    a = [1; 1; 3];   % fixed in A
    beta = [4; 1; 3]; % fixed in B

    % Normalize
    a = a / norm(a);
    beta = beta / norm(beta);

    % Rotation axis and angle
    lambda = cross(a, beta);
    if norm(lambda) < 1e-6
        disp("Vectors are parallel or opposite; no rotation needed or 180 deg rotation.")
        R = eye(3); % or special handling
        return
    end
    lambda = lambda / norm(lambda);
    theta = acos(dot(a, beta));

    % Skew-symmetric matrix
    L = [    0      -lambda(3)  lambda(2);
          lambda(3)     0      -lambda(1);
         -lambda(2) lambda(1)     0     ];

    % Rodrigues rotation matrix
    R = eye(3) + sin(theta)*L + (1 - cos(theta))*(L*L);

    % Display results
    fprintf("Rotation angle (rad): %.4f\n", theta);
    fprintf("Rotation axis: [%.4f, %.4f, %.4f]\n", lambda);
    disp("Rotation Matrix R:")
    disp(R)

    % Verify result: a should rotate to beta (approximately)
    disp("R * a =")
    disp(R * a)
    disp("Target beta =")
    disp(beta)
end
