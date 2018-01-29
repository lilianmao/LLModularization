# LLModularization

> LLModularization是一个iOS组件化系统，项目正在进行中。

本repository包含LLModularization和showLLModularization。

LLModularization是一个iOS组件化系统，结合了URLRouter和Protocol-class的思想（我是这么认为的）。每个组件需要用URL的形式注册自己提供的Service已经自己依赖的Service，组件之间调用就是采用URL的形式，每一个URL对应一个Service，一个Service对应一个实现Service的Instance，Instance可以任意变化，实现了依赖倒转。LLModularization同时输入组件与组件之间的调用关系，方便组件之间调试问题。

showLLModularization是对LLModularization调用关系的展示，用nodejs完成的。

## 项目的设计

### 模块图

![模块图](https://github.com/lilianmao/LLModularization/blob/feature/callChain_rootVC/Design/LLModularization.jpeg?raw=true)

### 类图

![类图](https://github.com/lilianmao/LLModularization/blob/feature/callChain_rootVC/Design/LLModularization_%E7%B1%BB%E5%9B%BE.jpg?raw=true)

### 序列图

LLModularization主要分注册和访问两个部分。

#### 注册
![注册](https://github.com/lilianmao/LLModularization/blob/master/Design/LLModularization_%E5%BA%8F%E5%88%97%E5%9B%BE(%E6%B3%A8%E5%86%8C).jpg?raw=true)

#### 访问
![访问](https://github.com/lilianmao/LLModularization/blob/feature/callChain_rootVC/Design/LLModularization_%E5%BA%8F%E5%88%97%E5%9B%BE(%E8%AE%BF%E9%97%AE).jpg?raw=true)

## 项目的运行

项目分两个部分：LLModularization和showLLModularization。

### LLModularization

<!--如果直接运行下载该框架可以在podfile里引入

```
pod 'LLModularization', '~> 1.0.0’
```-->

建议先下载demo，下载完成后

```
pod install
```

### showLLModularization

```
npm install
```

