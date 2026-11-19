use crate::common::Error;
#[cfg(feature = "image-data")]
use crate::common::ImageData;
use std::borrow::Cow;
use std::path::{Path, PathBuf};

pub struct Clipboard;

impl Clipboard {
	pub fn new() -> Result<Self, Error> {
		Ok(Self)
	}
}

pub struct Get<'a>(#[allow(dead_code)] pub(crate) &'a mut Clipboard);

impl<'a> Get<'a> {
	pub fn new(clipboard: &'a mut Clipboard) -> Self {
		Self(clipboard)
	}

	pub fn text(self) -> Result<String, Error> {
		Err(Error::ContentNotAvailable)
	}

	pub fn html(self) -> Result<String, Error> {
		Err(Error::ContentNotAvailable)
	}

	#[cfg(feature = "image-data")]
	pub fn image(self) -> Result<ImageData<'static>, Error> {
		Err(Error::ContentNotAvailable)
	}

	pub fn file_list(self) -> Result<Vec<PathBuf>, Error> {
		Err(Error::ContentNotAvailable)
	}
}

pub struct Set<'a>(#[allow(dead_code)] pub(crate) &'a mut Clipboard);

impl<'a> Set<'a> {
	pub fn new(clipboard: &'a mut Clipboard) -> Self {
		Self(clipboard)
	}

	pub fn text(self, _data: Cow<'_, str>) -> Result<(), Error> {
		Ok(())
	}

	pub fn html(self, _html: Cow<'_, str>, _alt: Option<Cow<'_, str>>) -> Result<(), Error> {
		Ok(())
	}

	#[cfg(feature = "image-data")]
	pub fn image(self, _image: ImageData<'_>) -> Result<(), Error> {
		Ok(())
	}

	pub fn file_list(self, _files: &[impl AsRef<Path>]) -> Result<(), Error> {
		Ok(())
	}
}

pub struct Clear<'a>(#[allow(dead_code)] pub(crate) &'a mut Clipboard);

impl<'a> Clear<'a> {
	pub fn new(clipboard: &'a mut Clipboard) -> Self {
		Self(clipboard)
	}

	pub fn clear(self) -> Result<(), Error> {
		Ok(())
	}
}
