const azureHelper = require("../models/helpers/azureHelper");
const Logger = require("../log/Logger")(__filename);

module.exports = {
  getList: async function (req, res) {
    const functionName = "controllers/getList";

    Logger.info(`${functionName}: Getting Hustler records...`);

    const items = getItems(req);
    Logger.debug(`${functionName}: Requested items: ${items.join(",")}`);

    if (items.length === 0) {
      res.status(400).send({
        status: false,
        msg: "Item Number(s) are required",
      });

      return;
    }

    Logger.info(`${functionName}: Getting products...`);
    const data = await getList(items);
    Logger.debug(`${functionName}: Products SQL records: ${data.length}`);
    const jsonList = parseListData(data);
    Logger.debug(`${functionName}: Products list: ${jsonList.length}`);

    Logger.info(`${functionName}: Getting accessories...`);
    const accessories = await getAccessores(items);
    Logger.debug(`${functionName}: Accessories SQL records: ${accessories.length}`);
    const jsonAccessories = parseAccessoresData(accessories);
    Logger.debug(`${functionName}: Accessories list: ${jsonAccessories.length}`);

    Logger.info(`${functionName}: Merging products and accessories...`);
    addAccessories(items, jsonList, jsonAccessories);

    Logger.info(`${functionName}: Cleanup and format...`);
    const response = formatResponse(jsonList);

    res.status(200).send(response);

    Logger.info(`${functionName}: Completed...`);
  },
};

function getItems(req) {
  const functionName = arguments.callee.name;

  let items = [];
  const { list } = req.body || {};

  if (list && list.length > 0) {
    items = list;
  } else {
    let itemNumber = req.query.itemNumber;

    if (Array.isArray(itemNumber)) {
      items = itemNumber;
    } else {
      items.push(itemNumber);
    }
  }

  items.forEach((item) => {
    item = item.toUpperCase();
  });

  return items;
}

async function getList(items) {
  const functionName = arguments.callee.name;

  const conn = await azureHelper.getConnection();
  const query = getListQuery(items);
  const response = await azureHelper.executeQuery(conn, query);

  if (response && response.recordset) {
    return response.recordset;
  } else {
    return [];
  }
}

function getListQuery(items) {
  const functionName = arguments.callee.name;

  if (!items || items.length === 0) {
    return "";
  }

  const itemsString = items.map((item) => `'${item}'`).join(",");

  return `SELECT
      A.PART_NUMBER AS partNumber,
      b.SPEC_NAME AS catentryId ,
      b.SPEC_NAME AS itemNumber ,
      b.SPEC_NAME AS name ,
      c.SHORT_DESCRIPTION AS shortDescription,
      c.LONG_DESCRIPTION longDescription,
      c.ACCESSORIES,
      b.SLUG ,
      b.ENGINE_MANUFACTURER ,
      b.ENGINE_HORSEPOWER ,
      b.DISPLACEMENT ,
      b.COOLING ,
      b.AIR_CLEANER ,
      b.ENGINE_WARRANTY ,
      b.SPEC_TYPE ,
      b.TRANSMISSION ,
      b.HYDRAULIC_LINES ,
      b.RESERVOIR_CAPACITY ,
      b.HYDRAULIC_COOLING ,
      b.FUEL_CAPACITY ,
      b.GROUND_SPEED_FWD ,
      b.PARKING_BRAKE ,
      b.CUTTING_WIDTH ,
      b.CUTTING_HEIGHT ,
      b.DECK_DEPTH ,
      b.DECK_LIFT ,
      b.NUMBER_OF_BLADES ,
      b.BLADE_LENGTH ,
      b.BLADE_TIP_SPEED ,
      b.SPINDLES ,
      b.DECK_ENGAGEMENT ,
      b.DECK_MATERIAL ,
      b.SPINDLE_MOUNTS ,
      b.IMPACT_TRIM_AREA ,
      b.ANTI_SCALP_WHEELS ,
      b.FRAME ,
      b.ENGINE_PLATE ,
      b.OPERATOR_PLATFORM ,
      b.FRONT_AXLE ,
      b.FRONT_CASTER_WHEEL ,
      b.FRONT_CASTER_FORK ,
      b.SEAT ,
      b.CUP_HOLDER ,
      b.FRONT_TIRE ,
      b.DRIVE_TIRE ,
      b.WING_TIRE ,
      b.WEIGHT ,
      b.HEIGHT ,
      b.SPECS_LENGTH ,
      b.WIDTH_W_CHUTE_UP ,
      b.TIRE_TO_TIRE_WIDTH ,
      b.PRODUCTIVITY ,
      b.WARRANTY ,
      b.CATCHER_STYLE ,
      b.POWERED_NON_POWERED ,
      b.CATCHER_CAPACITY ,
      b.MOWER_LENGTH_W_CATCHER ,
      b.MOWER_WIDTH_W_CATCHER ,
      b.STYLE_2_CATCHER_STYLE ,
      b.STYLE_2_POWERED_NON_POWERED ,
      b.STYLE_2_CATCHER_CAPACITY ,
      b.STYLE_2_MOWER_LENGTH_W_CATCHER,
      b.STYLE_2_MOWER_WIDTH_W_CATCHER,
      f.NAME ,
      f.SLUG ,
      f.CIRCLE_1_HEADING ,
      f.CIRCLE_1_BODY ,
      f.CIRCLE_2_HEADING ,
      f.CIRCLE_2_BODY ,
      f.CIRCLE_3_HEADING ,
      f.CIRCLE_3_BODY ,
      f.CIRCLE_4_HEADING ,
      f.CIRCLE_4_BODY ,
      f.CIRCLE_5_HEADING ,
      f.CIRCLE_5_BODY ,
      f.CIRCLE_6_HEADING ,
      f.CIRCLE_6_BODY ,
      f.CIRCLE_7_HEADING ,
      f.CIRCLE_7_BODY ,
      f.CIRCLE_8_HEADING ,
      f.CIRCLE_8_BODY ,
      f.CIRCLE_9_HEADING ,
      f.CIRCLE_9_BODY ,
      f.CIRCLE_10_HEADING,
      f.CIRCLE_10_BODY,
      g.CARD_DETAILS_LINE_1,
      g.CARD_DETAILS_LINE_2,
      g.CARD_DETAILS_LINE_3,
      g.CARD_DETAILS_LINE_4,
      g.CARD_DETAILS_LINE_5,
      h.IMAGE_1 ,
      h.IMAGE_2 ,
      h.IMAGE_3 ,
      h.IMAGE_4 ,
      h.IMAGE_5 ,
      h.IMAGE_6
    FROM
      specs_lookup a
    inner join
      specs_master b
    on
      trim(a.specs_lookup) = trim(b.spec_name)
    inner join
      hustler_master c
    on
      trim(a.model_line) = trim(c.product_name)
    INNER JOIN
      features_master_1 F
    ON
      trim(F.NAME) = trim(c.product_name)
    INNER JOIN
      features_master_2 G
    ON
      trim(F.NAME) = trim(G.NAME)
    INNER JOIN 
      HUSTLER_IMAGE_MASTER H
    ON
      TRIM(H.PRODUCT_NAME) = trim(c.product_name)
    WHERE
      A.PART_NUMBER IN (${itemsString})`;
}

function parseListData(items) {
  const functionName = arguments.callee.name;

  if (!items || items.length === 0) {
    return [];
  }

  const list = [];

  for (let i = 0; i < items.length; i++) {
    const item = items[i];

    const specs = getSpecs(item);
    const features = getFeatures(item);
    const images = getListImages(item);

    const itm = {
      partNumber: item.partNumber,
      catentryId: item.catentryId,
      itemNumber: item.itemNumber,
      name: item.name,
      shortDescription: item.shortDescription,
      longDescription: item.longDescription,
      category: null,
      siteURL: null,
      additionalModelNumber: "false",
      listPrices: [],
      offerPrices: [],
      attributes: {
        RATINGS: [],
        SPECS: specs,
        FEATURES: features,
      },
      relatedProducts: {
        "X-SELL": [],
        UPSELL: [],
        ACCESSORY: [],
      },
      images,
    };

    list.push(itm);
  }

  return list;
}

function getSpecs(item) {
  const functionName = arguments.callee.name;

  const props = [
    "ENGINE_MANUFACTURER",
    "ENGINE_HORSEPOWER",
    "DISPLACEMENT",
    "COOLING",
    "AIR_CLEANER",
    "ENGINE_WARRANTY",
    "SPEC_TYPE",
    "TRANSMISSION",
    "HYDRAULIC_LINES",
    "RESERVOIR_CAPACITY",
    "HYDRAULIC_COOLING",
    "FUEL_CAPACITY",
    "GROUND_SPEED_FWD",
    "PARKING_BRAKE",
    "CUTTING_WIDTH",
    "CUTTING_HEIGHT",
    "DECK_DEPTH",
    "DECK_LIFT",
    "NUMBER_OF_BLADES",
    "BLADE_LENGTH",
    "BLADE_TIP_SPEED",
    "SPINDLES",
    "DECK_ENGAGEMENT",
    "DECK_MATERIAL",
    "SPINDLE_MOUNTS",
    "IMPACT_TRIM_AREA",
    "ANTI_SCALP_WHEELS",
    "FRAME",
    "ENGINE_PLATE",
    "OPERATOR_PLATFORM",
    "FRONT_AXLE",
    "FRONT_CASTER_WHEEL",
    "FRONT_CASTER_FORK",
    "SEAT",
    "CUP_HOLDER",
    "FRONT_TIRE",
    "DRIVE_TIRE",
    "WING_TIRE",
    "WEIGHT",
    "HEIGHT",
    "SPECS_LENGTH",
    "WIDTH_W_CHUTE_UP",
    "TIRE_TO_TIRE_WIDTH",
    "PRODUCTIVITY",
    "WARRANTY",
    "CATCHER_STYLE",
    "POWERED_NON_POWERED",
    "CATCHER_CAPACITY",
    "MOWER_LENGTH_W_CATCHER",
    "MOWER_WIDTH_W_CATCHER",
    "STYLE_2_CATCHER_STYLE",
    "STYLE_2_POWERED_NON_POWERED",
    "STYLE_2_CATCHER_CAPACITY",
    "STYLE_2_MOWER_LENGTH_W_CATCHER",
    "STYLE_2_MOWER_WIDTH_W_CATCHER",
  ];

  return props.map((itm, index) => {
    return getSpec(item, itm, index + 1);
  });
}

function getSpec(item, prop, sequence) {
  const functionName = arguments.callee.name;

  let identifier = prop;
  if (identifier && identifier.length > 0) {
    identifier = identifier.replace(/_/g, "-").toLowerCase();
  }

  let name = prop;
  if (name && name.length > 0) {
    name = name.replace(/_/g, " ").toLowerCase();
  }

  const value = item[prop];

  return {
    identifier,
    name,
    grouping: "product specifications",
    values: [
      {
        value,
        sequence: 0,
      },
    ],
    sequence,
  };
}

function getFeatures(item) {
  const functionName = arguments.callee.name;

  const props = [
    "CIRCLE_1_BODY",
    "CIRCLE_2_HEADING",
    "CIRCLE_2_BODY",
    "CIRCLE_3_HEADING",
    "CIRCLE_3_BODY",
    "CIRCLE_4_HEADING",
    "CIRCLE_4_BODY",
    "CIRCLE_5_HEADING",
    "CIRCLE_5_BODY",
    "CIRCLE_6_HEADING",
    "CIRCLE_6_BODY",
    "CIRCLE_7_HEADING",
    "CIRCLE_7_BODY",
    "CIRCLE_8_HEADING",
    "CIRCLE_8_BODY",
    "CIRCLE_9_HEADING",
    "CIRCLE_9_BODY",
    "CIRCLE_10_HEADING",
    "CIRCLE_10_BODY",
    "CARD_DETAILS_LINE_1",
    "CARD_DETAILS_LINE_2",
    "CARD_DETAILS_LINE_3",
    "CARD_DETAILS_LINE_4",
    "CARD_DETAILS_LINE_5",
  ];

  let sequence = 1;

  const values = props
    .map((itm) => {
      const value = getFeatureValue(item, itm, sequence);

      if (value) {
        sequence += 1;
        return value;
      } else {
        return null;
      }
    })
    .filter((itm) => itm !== null);

  const feature = {
    identifier: "features",
    name: "Features",
    grouping: null,
    sequence: 1,
    values,
  };

  return [feature];
}

function getFeatureValue(item, prop, sequence) {
  const functionName = arguments.callee.name;

  const value = item[prop];

  if (value && value.length > 0) {
    return {
      sequence,
      value,
    };
  } else {
    return null;
  }
}

function getListImages(item) {
  const functionName = arguments.callee.name;

  const { IMAGE_1, IMAGE_2, IMAGE_3, IMAGE_4, IMAGE_5, IMAGE_6 } = item;
  return [IMAGE_1, IMAGE_2, IMAGE_3, IMAGE_4, IMAGE_5, IMAGE_6];
}

async function getAccessores(items) {
  const functionName = arguments.callee.name;

  const conn = await azureHelper.getConnection();
  const query = getAccessoriesQuery(items);
  const response = await azureHelper.executeQuery(conn, query);

  if (response && response.recordset) {
    return response.recordset;
  } else {
    return [];
  }
}

function getAccessoriesQuery(items) {
  const functionName = arguments.callee.name;

  if (!items || items.length === 0) {
    return "";
  }

  const itemsString = items.map((item) => `'${item}'`).join(",");

  return `SELECT
      A.PART_NUMBER AS partNumber,
      e.NAME       AS name              ,
      e.SLUG   AS catentryId                  ,
      e.TITLE        as shortDescription            ,
      e.[IMAGE]        as images          ,
      e.DESCRIPTION  as longDescription            
    FROM
              specs_lookup a
    inner join
              hustler_master c
    on
              trim(a.model_line) = trim(c.product_name)
    INNER JOIN
              ACCESS_lookup D
    ON
              trim(D.PRODUCT_NAME) = trim(c.product_name)
    INNER JOIN
              ACCESS_master E
    on
              trim(D.ACCESSORIES) = trim(E.SLUG)
    WHERE
              A.PART_NUMBER IN (${itemsString});`;
}

function parseAccessoresData(items) {
  const functionName = arguments.callee.name;

  if (!items || items.length === 0) {
    return [];
  }

  const list = [];

  for (let i = 0; i < items.length; i++) {
    const item = items[i];

    const itm = {
      partNumber: item.partNumber,
      name: item.name,
      catentryId: item.catentryId,
      itemNumber: null,
      shortDescription: item.shortDescription,
      longDescription: item.longDescription,
      category: null,
      siteURL: null,
      additionalModelNumber: "false",
      listPrices: [],
      offerPrices: [],
      attributes: {
        RATINGS: [],
        SPECS: [],
        FEATURES: [],
      },
      relatedProducts: {
        "X-SELL": [],
        UPSELL: [],
        ACCESSORY: [],
      },
      images: [item.images],
    };

    list.push(itm);
  }

  return list;
}

function addAccessories(items, jsonList, jsonAccessories) {
  const functionName = arguments.callee.name;

  for (let i = 0; i < items.length; i++) {
    const itemNumber = items[i];

    const item = jsonList.find((itm) => itm.partNumber === itemNumber);
    const accessories = jsonAccessories.filter((itm) => itm.partNumber === itemNumber);

    if (item && accessories) {
      item.relatedProducts.ACCESSORY = accessories;
    }
  }
}

function formatResponse(list) {
  const functionName = arguments.callee.name;

  const lst = [];

  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    const partNumber = item.partNumber;

    delete item.partNumber;

    const accessories = item.relatedProducts.ACCESSORY;

    for (let j = 0; j < accessories.length; j++) {
      const accessory = accessories[j];
      delete accessory.partNumber;
    }

    lst.push({
      id: partNumber,
      Commerce_JSON__c: item,
    });
  }

  return lst;
}
