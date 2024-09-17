import 'package:project2/models/food.dart';
import 'package:flutter/material.dart';

class Restaurant extends ChangeNotifier {
  Map<String, dynamic> allFood = {
    "viet": [
      Food(
          name: "Pho Bo (Beef Noodle Soup)",
          description:
              "Tender beef, rice noodles, and fragrant herbs in a rich, aromatic broth.",
          imagePath: "lib/images/Vietnamese/pho_bo.png",
          price: 12.95,
        ),
      Food(
          name: "Goi Cuon (Summer Rolls)",
          description:
              "Fresh rice paper rolls filled with shrimp, pork, vermicelli, and crisp vegetables.",
          imagePath: "lib/images/Vietnamese/goi_cuon.png",
          price: 8.95,
        ),
      Food(
          name: "Bun Cha (Grilled Pork with Noodles)",
          description:
              "Chargrilled pork patties and sliced pork belly served with rice vermicelli, herbs, and a tangy dipping sauce.",
          imagePath: "lib/images/Vietnamese/bun_cha.png",
          price: 14.95,
         ),
      Food(
          name: "Banh Mi (Vietnamese Sandwich)",
          description:
              "A crusty baguette filled with a combination of pâté, cured meats, pickled vegetables, and fresh herbs.",
          imagePath: "lib/images/Vietnamese/banh_mi.png",
          price: 9.95,
       ),
      Food(
          name: "Che (Vietnamese Dessert)",
          description:
              "A sweet and creamy coconut-based pudding with tapioca pearls, mung beans, and tropical fruits.",
          imagePath: "lib/images/Vietnamese/che.png",
          price: 6.95,
      ),
    ],
    "korean": [
      Food(
          name: "Bulgogi (Marinated Beef)",
          description:
              "Thinly sliced beef marinated in a sweet and savory sauce, grilled to perfection.",
          imagePath: "lib/images/Korean/bulgogi.png",
          price: 18.95,
         ),
      Food(
          name: "Kimchi Fried Rice",
          description:
              "Spicy fermented cabbage combined with rice, vegetables, and a fried egg",
          imagePath: "lib/images/Korean/kimchi_fried_rice.png",
          price: 12.95,
       ),
      Food(
          name: "Japchae",
          description:
              "Chewy sweet potato noodles stir-fried with vegetables, beef, and a sweet soy sauce.",
          imagePath: "lib/images/Korean/japchae.png",
          price: 14.95,
       ),
      Food(
          name: "Galbi (Grilled Short Ribs)",
          description:
              "Tender, marinated short ribs grilled tableside and served with ssamjang (dipping sauce).",
          imagePath: "lib/images/Korean/galbi.png",
          price: 24.95,
      ),
      Food(
          name: "Tteokbokki",
          description:
              "Chewy rice cakes simmered in a spicy, gochujang-based sauce with fish cakes and scallions",
          imagePath: "lib/images/Korean/tteokbokki.png",
          price: 11.95,
     ),
    ],
    "spanish": [
      Food(
          name: "Paella Valenciana",
          description:
              "A classic Spanish dish of saffron-infused rice with shrimp, chicken, and vegetables.",
          imagePath: "lib/images/Spanish/paella_valenciana.png",
          price: 22.95,
       ),
      Food(
          name: "Gazpacho",
          description:
              "A chilled tomato-based soup, bursting with fresh, vibrant flavors.",
          imagePath: "lib/images/Spanish/gazpacho.png",
          price: 8.95,
        ),
      Food(
          name: "Patatas Bravas",
          description:
              "Crispy fried potatoes served with a spicy tomato sauce and aioli.",
          imagePath: "lib/images/Spanish/patatas_bravas.png",
          price: 9.95,
       ),
      Food(
          name: "Gambas al Ajillo",
          description:
              "Shrimp sautéed in garlic-infused olive oil, with a sprinkle of red pepper flakes.",
          imagePath: "lib/images/Spanish/gambas_al_ajillo.png",
          price: 16.95,
        ),
      Food(
          name: "Crema Catalana",
          description:
              "A rich, creamy custard dessert with a caramelized sugar topping.",
          imagePath: "lib/images/Spanish/crema_catalana.png",
          price: 7.95,
       ),
    ],
    "italian": [
      Food(
          name: "Margherita Pizza",
          description:
              "A classic Neapolitan pizza with tomato sauce, fresh mozzarella, and basil.",
          imagePath: "lib/images/Italian/margherita_pizza.png",
          price: 12.95,
    ),
      Food(
          name: "Spaghetti Carbonara",
          description:
              "Pasta tossed with eggs, pancetta, Parmesan, and black pepper.",
          imagePath: "lib/images/Italian/spaghetti_carbonara.png",
          price: 14.95,
       ),
      Food(
          name: "Lasagna",
          description:
              "Layers of pasta, ground beef, ricotta, and a rich tomato sauce, baked to perfection.",
          imagePath: "lib/images/Italian/lasagna.png",
          price: 16.95,
       ),
      Food(
          name: "Caprese Salad",
          description:
              "Sliced tomatoes, fresh mozzarella, basil, and a drizzle of balsamic reduction.",
          imagePath: "lib/images/Italian/caprese_salad.png",
          price: 10.95,
        ),
      Food(
          name: "Tiramisu",
          description:
              "A decadent Italian dessert of ladyfingers soaked in coffee, layered with mascarpone and dusted with cocoa.",
          imagePath: "lib/images/Italian/tiramisu.png",
          price: 8.95,
       ),
    ],
    "american": [
      Food(
          name: "Cheeseburger",
          description:
              "A juicy beef patty topped with melted cheese, lettuce, tomato, onion, and condiments, served on a brioche bun.",
          imagePath: "lib/images/American/cheeseburger.png",
          price: 12.95,
      ),
      Food(
          name: "Mac and Cheese",
          description:
              "Creamy, indulgent macaroni and cheese, baked to a golden brown crust.",
          imagePath: "lib/images/American/mac_and_cheese.png",
          price: 9.95,
      ),
      Food(
          name: "BBQ Ribs",
          description:
              "Tender, fall-off-the-bone pork ribs, smothered in a tangy, smoky barbecue sauce.",
          imagePath: "lib/images/American/bbq_ribs.png",
          price: 18.95,
     ),
      Food(
          name: "Cobb Salad",
          description:
              "A composed salad with grilled chicken, bacon, avocado, hard-boiled egg, and various other toppings.",
          imagePath: "lib/images/American/cobb_salad.png",
          price: 13.95,
       ),
      Food(
          name: "Apple Pie",
          description:
              "A classic American dessert with a flaky crust and a sweet, cinnamon-spiced apple filling.",
          imagePath: "lib/images/American/apple_pie.png",
          price: 6.95,
      ),
    ],
  };
}