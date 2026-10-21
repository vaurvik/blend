//! Golden-image tests for Blend's renderer (test-only crate; the library is empty).
//!
//! `tests/golden.rs` builds small procedural projects (no media files), renders one frame of each
//! through the CPU reference compositor (`blend-render`) and compares it with a committed PNG
//! in `goldens/` using `blend_testkit::golden`. The same scenes are composited on the GPU
//! (`blend-gpu`) when an adapter is available and compared with the CPU result.
//!
//! Regenerate references with `BLEND_BLESS=1 cargo test -p blend-golden`.
