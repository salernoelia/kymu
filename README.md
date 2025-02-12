# thesis-telerehab-app

**Link Database**

```sh
supabase link --project-ref vdrwkcubtpypoysioqiw
```

**Pull migrations of Supabase DB for backup**

```sh
supabase db pull
```

**Generate Types of Supabase DB**

```sh
npx supabase gen types typescript --project-id "vdrwkcubtpypoysioqiw" --schema public > database.types.ts
```
