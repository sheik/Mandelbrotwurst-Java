import java.math.BigDecimal;

public class Mandelbrot {
	private int max_iterations;

	public Mandelbrot() {
		this.max_iterations = 1000;
	}

	public Mandelbrot(int i) {
		if(i > 0) 
			this.max_iterations = i;
	}

	public int in_set(ComplexBigDecimal z) {
		ComplexBigDecimal z_orig = z;
		int is_inside = -1;

		for(int n = 0; n < this.max_iterations; ++n) {
			if(z.absSquared().compareTo(new BigDecimal(4)) == -1)  {
				is_inside = n;
				break;
			}

			z = z.square().add(z_orig);
		}

		return is_inside;
	}
}
