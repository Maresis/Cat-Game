class PathNode {
    int x, y; // position
    float g, h, f; //values for a* algorithm
    PathNode parent;

    public PathNode(int x, int y, float g, float h, PathNode parent){
        this.x = x;
        this.y = y;
        this.g = g;
        this.h = h;
        this.f = g + h; //the combined value of g and h determines what is the best path.
        this.parent = parent;
    }
}