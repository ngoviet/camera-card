# Hướng dẫn cài Yarn và chạy yarn install

## Cách 1: Cài Yarn qua npm (nếu đã có Node.js)

```bash
npm install -g yarn
```

Sau đó chạy:
```bash
yarn install
```

## Cách 2: Cài Yarn qua Corepack (Node.js 16.10+)

```bash
corepack enable
corepack prepare yarn@stable --activate
```

Sau đó chạy:
```bash
yarn install
```

## Cách 3: Cài Yarn qua Volta (khuyến nghị cho project này)

Project này sử dụng Volta để quản lý Node và Yarn version.

1. Cài Volta: https://volta.sh/
2. Volta sẽ tự động cài đúng version Node và Yarn khi bạn chạy lệnh
3. Chạy: `yarn install`

## Sau khi chạy yarn install thành công:

1. Kiểm tra yarn.lock có thay đổi:
   ```bash
   git status yarn.lock
   ```

2. Nếu có thay đổi, commit và push:
   ```bash
   git add yarn.lock
   git commit -m "chore: update yarn.lock"
   git push origin main
   ```

## Lưu ý:

- Nếu yarn install báo lỗi về lockfile, có thể cần xóa yarn.lock và chạy lại
- Đảm bảo patch file cho sass có trong `.yarn/patches/`

