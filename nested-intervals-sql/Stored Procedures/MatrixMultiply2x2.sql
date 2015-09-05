CREATE PROCEDURE MatrixMultiply2x2 (
	@a11 BIGINT,
	@a12 BIGINT,
	@a21 BIGINT,
	@a22 BIGINT,
	@b11 BIGINT,
	@b12 BIGINT,
	@b21 BIGINT,
	@b22 BIGINT,
	@ab11 BIGINT = NULL OUTPUT,
	@ab12 BIGINT = NULL OUTPUT,
	@ab21 BIGINT = NULL OUTPUT,
	@ab22 BIGINT = NULL OUTPUT
)
AS
	SET NOCOUNT ON

	-- HACK: well, it DOES multiply 2 2x2 matricies...
	SET @ab11 = (@a11 * @b11) + (@a12 * @b21)
	SET @ab12 = (@a11 * @b12) + (@a12 * @b22)
	SET @ab21 = (@a21 * @b11) + (@a22 * @b21)
	SET @ab22 = (@a21 * @b12) + (@a22 * @b22)
RETURN
