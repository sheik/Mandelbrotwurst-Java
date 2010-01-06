// number crunching class
// that will be used for multi-threading
public class Cruncher extends Thread {

	// the screen [width][height]
	// each int will represent the number
	// of iterations before being thrown out
	// of the mandelbrot set (shared data)
	private static int[][] screen;

	// width and height of screen, stored
	// for handiness
	private static int width, height;

	// the starting and ending positions
	// of the portion of screen to be filled
	// by this thread
	private int x_start, x_end, y_start, y_end;

	// total_threads is the number of threads
	// intended to run
	// id is simply the 0th indexed id
	public Cruncher(int total_threads, int id) {
		this.x_start = Cruncher.width / total_threads * id;
		this.x_end = Cruncher.width / total_threads * (id+1);

		this.y_start = Cruncher.height / total_threads * id;
		this.y_end = Cruncher.height / total_threads * (id+1);
	}

	// fill in this thread's portion of
	// the screen
	public void run() {
		for(int x = this.x_start; x < this.x_end; x++) {
			for(int y = 0; y < height; y++) {
				synchronized(this) {
					Cruncher.screen[x][y] = x+y;
				}
			}
		}
	}

	// set the total size of the
	// screen to be filled (shared data)
	public static void setScreen(int width, int height) {
		screen = new int[width][height];
		Cruncher.width = width;
		Cruncher.height = height;
	}

	public static int[][] getScreen() {
		return screen;
	}
}

