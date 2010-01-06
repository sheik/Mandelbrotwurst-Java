import java.math.*;
import java.util.concurrent.Semaphore;


class FractalCalc {
	// height and width of viewing
	// box in pixels
	private int image_width, image_height;

	// boundaries of the screen 
	private BigDecimal min_r, max_r, min_i, max_i;

	// distance from center to sides of screen
	private BigDecimal increment;

	// center of screen in complex notation
	private BigDecimal center_x, center_y;

	private Cruncher[] crunchers;

	public FractalCalc(int width, int height, int threads) {
		Cruncher.setScreen(width, height);
		this.crunchers = new Cruncher[threads];
		for(int i = 0; i < threads; i++) {
			this.crunchers[i] = new Cruncher(threads, i);
		}
	}

	public int[][] draw() throws InterruptedException {
		for(int i = 0; i < crunchers.length; i++) {
			crunchers[i].start();
		}
		for(int i = 0; i < crunchers.length; i++) {
			crunchers[i].join();
		}

		return Cruncher.getScreen();
	}

}

