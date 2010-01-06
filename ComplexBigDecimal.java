import java.math.BigDecimal;

public class ComplexBigDecimal {
	private BigDecimal re, im;

	public ComplexBigDecimal(BigDecimal re, BigDecimal im) {
		this.re = re;
		this.im = im;
	}

	public ComplexBigDecimal(double re, double im) {
		this.re = new BigDecimal(re);
		this.im = new BigDecimal(im);
	}

	public ComplexBigDecimal(int re, int im) {
		this.re = new BigDecimal(re);
		this.im = new BigDecimal(im);
	}

	public BigDecimal absSquared() {
		return re.multiply(re).add(im.multiply(im));
	}

	public ComplexBigDecimal square() {
		return new ComplexBigDecimal(
				re.multiply(re).subtract(im.multiply(im)),
				re.multiply(im).multiply(new BigDecimal(2.0))
			);

	}

	public BigDecimal getRe() {
		return this.re;
	}

	public BigDecimal getIm() {
		return this.im;
	}

	public ComplexBigDecimal add(ComplexBigDecimal b) {
		return new ComplexBigDecimal(
				re.add(b.getRe()),
				im.add(b.getIm())
			);
	}

}
