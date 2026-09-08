# Component Boundary Patterns

## Route-separable screens

When routes already express different workflows, use different page components. Share a form or display component only when its fields and responsibilities are the same; keep titles, default values, and submit actions in the page that owns them.

```tsx
export const CreateProductPage = () => (
	<ProductForm defaultValues={emptyProduct} onSubmit={createProduct} />
);

export const EditProductPage = ({ product }: { product: Product }) => (
	<ProductForm defaultValues={product} onSubmit={(values) => updateProduct(product.id, values)} />
);
```

## Data-driven variation

When a discriminated union determines the UI, branch once at a dispatcher instead of repeating the discriminator for rendering, actions, and navigation.

```tsx
const StorageItemRow = ({ item }: { item: StorageItem }) => {
	switch (item.type) {
		case 'folder':
			return <FolderRow folder={item} />;
		case 'file':
			return <FileRow file={item} />;
	}
};
```

## Small local differences

Use a concrete feature prop or a named slot when the base component remains responsible for the same thing. Do not use a role prop to smuggle an independent workflow into it.

```tsx
<ProductDetail product={product} showStockWarning />
```

If a second or third feature option changes navigation, permissions, or validation, split at the feature boundary instead.
