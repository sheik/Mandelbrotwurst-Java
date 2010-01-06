/*
 * Mandelbrot Explorer 
 * 
 * Jeff Aigner 2009-2010. 
 * TODO:
 * Replace double with BigDecimal for arbitrary precision
 * Refactor into classes mimicking C++ code
 * Ensure proper scaling for non-square viewports
 * Possibly re-add video making feature
 *
 */
 
import processing.video.*;
import java.math.*;
 
// height and width
int image_width = 600;
int image_height = 600;
 
// initial scaling information for real and imaginary parts
double min_r = -1.275;
double max_r = 2.02;
double min_i = -1.493;
double max_i = min_i + (max_r - min_r) * image_height / image_width;

double increment = 2.0;
double center_x = -1.0;
double center_y = 0.0;

boolean drawing = false;
 
// variables for color normalization
int min_value = 0, max_value = 0;
int[] counts = new int[255];
int[][] pix = new int[image_width][image_height];
 
void setup() {
  // size and dark grey background
  size(image_width, image_height);
  background(255, 255, 255);
//  doDraw(center_x, center_y, increment);

  FractalCalc<Mandelbrot> fa = new FractalCalc(600, 600, 20);

  try {
	  int[][] testing = fa.draw();
	  // iterate over our set of pixels
	  // and color / draw them to screen
	  for(int y = 0; y < image_height; ++y) {
		  for(int x = 0; x < image_width; ++x) {
			  int col = testing[ x ][ y ];

			  // color normalizer
			  max_value = 2000;
			  min_value = 0;

			  stroke((col / 3 * 2) % 255, ( col / 3 ) * 255 / max_value, col * 255 / max_value );
			  point(x, y);
		  }
	  }
  } catch(InterruptedException e) {
	  System.out.println("Something b0rked");
  }
}
 
 
// calculate scale factor
double r_factor = (max_r - min_r) / (image_width - 1);
double i_factor = (max_i - min_i) / (image_height - 1);
 
// max number of iterations per pixel
// increase iterations for a wider range of color and detail
// this increases the processing time per-zoom by a very
// large factor. 
int max_iterations = 1500, colour = 0;

// variables used for mandelbrot calculations
double c_i, c_r, z_r, z_i, is_inside = 0;
 

// zoom in on mouse and redraw
void mouseClicked() {
  min_r = center_x - increment;
  max_r = center_x + increment;
  
  min_i = center_y - increment;
  max_i = center_y + increment;
  
  r_factor = (max_r - min_r) / (image_width - 1);
  i_factor = (max_i - min_i) / (image_height - 1);
  
  double new_x = min_r + mouseX * r_factor;
  double new_y = max_i - mouseY * i_factor;
  
  increment = increment / 4.0;
  doDraw(new_x, new_y, increment);
  center_x = new_x;
  center_y = new_y;
}

 

// update the screen, function works like this:
// cx: real part of complex number
// cy: imaginary part of complex number
// inc: increment to use from complex number to
//      the edges of the screen
void doDraw(double cx, double cy, double inc) {
  if(drawing == false) {
    drawing = true;
    min_value = 0;
    max_value = 0;
    
    min_r = cx - inc;
    max_r = cx + inc;
    
    min_i = cy - inc;
    max_i = cy + inc;
    
    r_factor = (max_r - min_r) / (image_width);
    i_factor = (max_i - min_i) / (image_height);
   
    for(int y = 0; y < image_height; ++y) {
      c_i = max_i - y * i_factor;
    
      for(int x = 0; x < image_width; ++x) {
        c_r = min_r + x * r_factor;
        z_r = c_r;
        z_i = c_i;
        is_inside = 1;
    
        // see if pixel is in the mandelbrot set
        for(int n = 0; n < max_iterations; ++n) {
          double z_r2 = z_r * z_r;
          double z_i2 = z_i * z_i;
    
          if((z_r2 + z_i2) > 4) {
            is_inside = 0;
            colour = n;
            break;
          }
    
          z_i = 2 * z_r * z_i + c_i;
          z_r = z_r2 - z_i2 + c_r;      
        }
    
        // generate pixels. Black if in set, otherwise
        // generate a color based on the number of iterations
        // it made it through before being thrown out
        if(is_inside == 1) {
          colour = 0;
        } 
        else {
          if(colour < min_value || min_value == 0) {
            min_value = colour;
          }
          if(colour > max_value) {
            max_value = colour;
          }
        }
        pix[ x ][ y ] = colour; // store pixel info for later coloring / drawing
      } 
    }

	// iterate over our set of pixels
	// and color / draw them to screen
    for(int y = 0; y < image_height; ++y) {
      for(int x = 0; x < image_width; ++x) {
        int col = pix[ x ][ y ];

		// color normalizer
        stroke((col / 3 * 2) % 255, ( col / 3 ) * 255 / max_value, col * 255 / max_value );
        point(x, y);
      }
    }
    drawing = false;
  }
}

// currently empty because draw
// is controlled by clicking
void draw() {
  
}

// debugging function for showing mouse coordinates
// and the complex numbers that they map to
void showCoords() {
  System.out.println("Mouse X: " + mouseX);
  System.out.println("Mouse Y: " + mouseY);
  min_r = center_x - increment;
  max_r = center_x + increment;
  
  min_i = center_y - increment;
  max_i = center_y + increment;
  
  r_factor = (max_r - min_r) / (image_width - 1);
  i_factor = (max_i - min_i) / (image_height - 1);

  double new_x = min_r + mouseX * r_factor;
  double new_y = max_i - mouseY * i_factor;
  
  System.out.println("Current center x: " + center_x);
  System.out.println("Current center y: " + center_y);
  System.out.println("New center x: " + new_x);
  System.out.println("New center y: " + new_y);  
}

