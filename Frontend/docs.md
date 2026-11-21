

## Step 1 : Project setup karo

Under frontend directory, to create project named 'project' itself, run command given in below : 
```
npm create vite@latest project -- --template react
```


## Step 2: React dependencies install karo

```
PS C:\@Intelligence\CODEE\Projects\Running\FullStack-RestAPIs\Frontend> cd project
PS C:\@Intelligence\CODEE\Projects\Running\FullStack-RestAPIs\Frontend\project> npm install
```

## Step 3: Vite ko port 8080 par configure karo

frontend/project/vite.config.js open karke isse replace kar do:
```
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 8080,
    strictPort: true,
  },
})
```

## Step 4: React project run karo

```
PS C:\@Intelligence\CODEE\Projects\Running\FullStack-RestAPIs\Frontend\project> npm run dev
```

Ab browser mein open karo:
```
http://localhost:8080
```


