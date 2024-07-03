# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.5]

### Added

- Taxes equality by code.

## [0.0.4]

### Fixes

- Discounts calculations cannot be negative.

## [0.0.3]

### Added

- Obtain list of products with sale discount included (*itemsWithSaleDiscount*).

## [0.0.2]

### Changed

- Discount property *affectTax* renamed to *affectSubtotalBeforeTaxes* to clarify purpose.
- Tax property *affectTax* renamed to *affectNextTaxSubtotal* to clarify purpose.

## [0.0.1]

### Added

- Discount data model with calculation methods.
- Tax data model with calculation methods.
- Item data model with calculation methods.
- Sale data model with calculation methods.
- Example for SRI invoice (Ecuador).
