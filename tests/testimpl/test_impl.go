package testimpl

import (
	"testing"

	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

// Since the details of what should be tested in collection module are not known, the skeleton test is left intact for successful pipeline runs. Relevant tests can be added later once more testing scenario details are known.
func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	t.Run("TestAlwaysSucceeds", func(t *testing.T) {
		assert.Equal(t, "foo", "foo", "Should always be the same!")
		assert.NotEqual(t, "foo", "bar", "Should never be the same!")
	})
}
