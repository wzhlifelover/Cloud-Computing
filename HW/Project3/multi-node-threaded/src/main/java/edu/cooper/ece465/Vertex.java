package edu.cooper.ece465;

import java.io.Serializable;

/**
* The Vertex class implements every node in the graph
*/
public class Vertex implements Serializable {
    int src;   // source node's key value
    int val;   // node's key value
    int dist;  // node's distance from the initial node

    public Vertex(int src, int val, int dist){
        this.src = src;
        this.val = val;
        this.dist = dist;
    }
}
