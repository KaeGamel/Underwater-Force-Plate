function [angle,angleDeg] = abc_angle(a, b, c, varargin)
% Compute the abc angle, where the abc angle is the angle seen from point b
% looking at a and c. Points A, B and C are 2D positions (e.g. a=[2,10],
% b=[1,3], c=[5,1]).
%
% Optional input arguments (varargin) include:
%
% 1) Side should be either 0 for left and 1 for right (default 0)
% 2) Vector_up should be a 3D vector pointing upwards (default [0, 0, 1])
%
% Output arguments:
% 
% 1) angle = 2D angle in radians
% 2) angleDeg = 2D angle in degrees
% 
% Written by Jonathan Patrick Arreguit O'Neill
% Modified by Kathleen L. Foster Aug 24, 2018


    if ~isempty(varargin) == 0
        side = 0;
        vector_up = [0, 0, 1];
    elseif ~isempty(varargin) == 1
        side = varargin{1};
        if length(varargin)<2
            vector_up = [0, 0, 1];
        else
            side = varargin{1};
            vector_up = varargin{2};
        end
    end

    % Normalise
    ba = normalise(a - b);
    bc = normalise(c - b);
    % Convert to 3D
    if length(ba(:)) == 2
        ba = vector_flat_3d(ba);
    end
    if length(bc(:)) == 2
        bc = vector_flat_3d(bc);
    end

    % Internal angle
    angle = acos(dot(transpose(ba), transpose(bc)));
    % Cross product for treating case
    z = cross(transpose(ba), transpose(bc));
    % Treat cases
    if side == 0
        external = dot(z, vector_up) <= 0.0;
    else
        external = dot(z, vector_up) >= 0.0;
    end
    if external  % External angle must be used, not internal
        angle = 2*pi - angle;
    end
    
    angleDeg=rad2deg(angle);
end

function vout = vector_flat_3d(v)
% Give a 2D vector and obtain a flat 3D
    vout = [v(1), v(2), 0];
end

function v_normalised =  normalise(v)
% Normalise vector
    v_norm = norm(v);
    if v_norm > 1e-9
        v_normalised = v./v_norm;
    else
        v_normalised = v;
    end
end